import SwiftUI
import AVFoundation

struct CustomCameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: CustomCameraView
        
        init(_ parent: CustomCameraView) {
            self.parent = parent
        }
    }
}

protocol CameraViewControllerDelegate: AnyObject {
    func didFinishRecording(outputFileURL: URL)
}

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    var movieOutput: AVCaptureMovieFileOutput!
    var isRecording = false
    var recordButton: UIButton!
    weak var delegate: (any CameraViewControllerDelegate)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // レイアウト更新後にビューのサイズを設定
        videoPreviewLayer?.frame = view.bounds
        
        // ボタンの位置を更新
        let buttonSize: CGFloat = 70
        recordButton?.frame = CGRect(
            x: (view.bounds.width - buttonSize) / 2,
            y: view.bounds.height - buttonSize - 50,  // 下端から50ポイント上
            width: buttonSize,
            height: buttonSize
        )
        
        // ガイドの位置を更新
        if let guideView = view.subviews.first(where: { $0 is CircleView }) {
            let size = view.bounds.width - 4
            guideView.frame = CGRect(
                x: 2,
                y: (view.bounds.height - size) / 2 - (view.bounds.height * 0.22),  // 画面の高さの15%分上に移動（これでcircleの高さを調整）

                width: size,
                height: size
            )
        }
    }

    private func setupCamera() {
        // カメラセッションの初期化
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        // デバイスの設定（リアカメラ）
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("カメラデバイスが見つかりません")
            return
        }
        
        captureDevice = device
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("カメラデバイスの設定エラー: \(error)")
            return
        }

        // ビデオ出力の設定
        movieOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }

        // プレビューレイヤーの設定
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)

        // 円形ガイドの追加
        let guideView = CircleView(frame: .zero)  // フレームは viewDidLayoutSubviews で設定
        view.addSubview(guideView)

        // 撮影ボタンを追加
        recordButton = UIButton(frame: .zero)  // フレームは viewDidLayoutSubviews で設定
        recordButton.backgroundColor = .red
        recordButton.layer.cornerRadius = 35
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        view.addSubview(recordButton)

        // セッション開始（バックグラウンドで実行）
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    @objc func toggleRecording() {
        if isRecording {
            // 撮影を停止
            movieOutput.stopRecording()
            isRecording = false
            toggleFlash(false)
            recordButton.backgroundColor = .red
        } else {
            // 撮影を開始
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let outputPath = documentsPath.appendingPathComponent("tempMovie.mov")
            let outputURL = URL(fileURLWithPath: outputPath)
            
            // 既存のファイルを削除
            if FileManager.default.fileExists(atPath: outputPath) {
                try? FileManager.default.removeItem(at: outputURL)
            }
            
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            isRecording = true
            toggleFlash(true)
            recordButton.backgroundColor = .green
        }
    }

    func toggleFlash(_ isOn: Bool) {
        guard let device = captureDevice,
              device.hasTorch,
              device.isTorchAvailable else { return }
              
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            if isOn {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("フラッシュ設定エラー: \(error)")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            // 録画が正常に終了した場合の処理
            ResultHolder.GetInstance().SetMovieUrls(Url: outputFileURL.absoluteString)
            
            DispatchQueue.main.async { [weak self] in
                // デリゲートを通じて撮影完了を通知
                self?.delegate?.didFinishRecording(outputFileURL: outputFileURL)
                // 前の画面に戻る
                self?.dismiss(animated: true)
            }
        } else {
            print("録画エラー: \(error?.localizedDescription ?? "不明なエラー")")
        }
    }
}

extension CustomCameraView.Coordinator: CameraViewControllerDelegate {
    func didFinishRecording(outputFileURL: URL) {
        // ResultHolderに録画URLを保存
        ResultHolder.GetInstance().SetMovieUrls(Url: outputFileURL.absoluteString)
        // 撮影画面を閉じる
        parent.presentationMode.wrappedValue.dismiss()
    }
}

class CircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(3.0)
            UIColor.red.set()
            
            let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
            let radius = min(rect.size.width, rect.size.height) / 2.3
            
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            context.strokePath()
        }
    }
}
