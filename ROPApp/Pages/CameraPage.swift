//
//  CameraPage.swift
//  ROPApp
//
//  Created by Yoshiyuki Kitaguchi on 2024/12/03.
//

import SwiftUI

struct CameraPage: View {
    @ObservedObject var user: User
    @State var isCustomCameraActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("カメラページ")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    isCustomCameraActive = true
                }) {
                    Text("カスタムカメラを開く")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(
                    destination: CustomCameraView(),
                    isActive: $isCustomCameraActive,
                    label: {
                        EmptyView()
                    }
                )
            }
            .navigationBarTitle("カメラページ", displayMode: .inline)
        }
    }
}
