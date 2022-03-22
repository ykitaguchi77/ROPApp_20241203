//
//  howToTakeBlink.swift
//  MovieApp
//
//  Created by Yoshiyuki Kitaguchi on 2022/02/22.
//
import SwiftUI
import CryptoKit
import AVKit

struct HowToTakeRotate: View {
    
    @ObservedObject var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var imageData : Data = .init(capacity:0)
    @State var rawImage : Data = .init(capacity:0)
    @State var source:UIImagePickerController.SourceType = .camera

    @State var isActionSheet = true
    @State var isImagePicker = true
    @State private var goTakePhoto: Bool = false  //撮影ボタン
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Tutorial", withExtension: "mp4")!)
    
    
    var body: some View {
        NavigationView{
            GeometryReader{bodyView in
                VStack(spacing:0){
                    ScrollView{
                        Group{
                        Text("Rotate")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.bottom)

                        Text("①楕円形のガイドに顔の輪郭を合わせる")
                            .font(.title2)
                            .frame(width: bodyView.size.width, alignment: .leading)
                            .padding(.bottom)

                        Text("②画面上部にあるカメラを固視")
                            .font(.title2)
                            .frame(width: bodyView.size.width, alignment: .leading)

                            //.padding(.bottom)
                        Image("starePoint")
                            .resizable()
                            .scaledToFit()
                            .frame(width: bodyView.size.width)
                            .padding(.bottom)

                        Text("③撮影ボタンを押す")
                            .font(.title2)
                            .frame(width: bodyView.size.width, alignment: .leading)
                            .padding(.bottom)

                        Text("④まずは正面視で")
                            .font(.title2)
                            .frame(width: bodyView.size.width, alignment: .leading)
                            .padding(.bottom)
                            
                        Text("⑤カメラを見たままで顔をゆっくりと回転させる")
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .frame(width: bodyView.size.width, alignment: .leading)
                            .padding(.bottom)
                            
                        Text("⑥3回顔を回したら撮影終了")
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .frame(width: bodyView.size.width, alignment: .leading)
                            
                        }
                        
                        //Tutorial動画
                        ZStack{
                            VideoPlayer(player: player).frame(width: bodyView.size.width, height:bodyView.size.width)
                        }
                        

                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack{
                                Image(systemName: "arrowshape.turn.up.backward")
                                Text("戻る")
                            }
                                .foregroundColor(Color.white)
                                .font(Font.largeTitle)
                        }
                            .frame(minWidth:0, maxWidth:CGFloat.infinity, minHeight: 75)
                            .background(Color.black)
                            .padding()
                    }
                }
            }
        }
    

    }

}
