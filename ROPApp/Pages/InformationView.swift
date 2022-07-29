//
//  Informations.swift
//  CorneaApp
//
//  Created by Yoshiyuki Kitaguchi on 2021/04/18.
//
import SwiftUI

//変数を定義
struct Informations: View {
    @ObservedObject var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isSaved = false
    @State private var goTakePhoto: Bool = false  //撮影ボタン
    @State private var temp = "" //スキャン結果格納用の変数
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                Form{
                    Section(header: Text("患者情報"), footer: Text("")){
                    
                        HStack{
                            Text("入力日時")
                            Text(self.user.date, style: .date)
                        }
                        
                        
                        Picker(selection: $user.selected_hospital,
                                   label: Text("施設")) {
                            ForEach(0..<user.hospitals.count) {
                                Text(self.user.hospitals[$0])
                                     }
                            }
                           .onChange(of: user.selected_hospital) {_ in
                               self.user.isSendData = false
                               UserDefaults.standard.set(user.selected_hospital, forKey:"hospitaldefault")
                           }
                        
                        //DatePicker("入力日時", selection: $user.date)
                        
                        HStack {
                            Text("I D ")
                            TextField("idを入力してください", text: $user.id)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: user.id) { _ in
                                self.user.isSendData = false
                                }
                            ScanButton(text: $user.id)
                            .frame(width: 100, height: 30, alignment: .leading)
                        }
                        
                        HStack{
                            Text("性別")
                            Picker(selection: $user.selected_gender,
                                       label: Text("性別")) {
                                ForEach(0..<user.gender.count) {
                                    Text(self.user.gender[$0])
                                        }
                                }
                                .onChange(of: user.selected_gender) {_ in
                                    self.user.isSendData = false
                                    }
                                .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        HStack{
                            Text("生年月日")
                            TextField("1970年3月8日 →19700308と入力", text: $user.birthdate)
                                .keyboardType(.numbersAndPunctuation)
                        }.layoutPriority(1)
                        .onChange(of: user.birthdate) { _ in
                        self.user.isSendData = false
                        }
                        
                        
                      
                        Picker(selection: $user.selected_gestWeek,
                               label: Text("在胎週数")) {
                            ForEach(21..<40){ week in
                                Text("\(week)週")
                            }
                        }
                       .onChange(of: user.selected_gestWeek) { _ in
                           self.user.isSendData = false
                           print("seleced_gestWeek: \(user.selected_gestWeek)")
                           print("gestWeek: \(user.gestWeek[user.selected_gestWeek])")
                           }
                    }

            
//                    Section(header: Text("疾患情報"), footer: Text("")){
//                        HStack{
//                            Text("Side")
//                            Picker(selection: $user.selected_side,
//                                       label: Text("右or左")) {
//                                ForEach(0..<user.side.count) {
//                                    Text(self.user.side[$0])
//                                        }
//                                }
//                                .onChange(of: user.selected_side) {_ in
//                                    self.user.isSendData = false
//                                    }
//                                .pickerStyle(SegmentedPickerStyle())
//                        }
//                        
//                        HStack{
//                            Text("Zone")
//                            Picker(selection: $user.selected_zone,
//                                       label: Text("")) {
//                                ForEach(0..<user.zone.count) {
//                                    Text(self.user.zone[$0])
//                                        }
//                                }
//                                .onChange(of: user.selected_zone) {_ in
//                                    self.user.isSendData = false
//                                    }
//                                .pickerStyle(SegmentedPickerStyle())
//                        }
//                        
//
//                        HStack{
//                            Text("Stage")
//                            Picker(selection: $user.selected_stage,
//                                       label: Text("")) {
//                                ForEach(0..<user.stage.count) {
//                                    Text(self.user.stage[$0])
//                                        }
//                                }
//                                .onChange(of: user.selected_stage) {_ in
//                                    self.user.isSendData = false
//                                    }
//                                .pickerStyle(SegmentedPickerStyle())
//                        }
//                        
//                        HStack{
//                            Text("Plus/No-plus")
//                            Picker(selection: $user.selected_plusDisease,
//                                       label: Text("")) {
//                                ForEach(0..<user.plusDisease.count) {
//                                    Text(self.user.plusDisease[$0])
//                                        }
//                                }
//                                .onChange(of: user.selected_plusDisease) {_ in
//                                    self.user.isSendData = false
//                                    }
//                                .pickerStyle(SegmentedPickerStyle())
//                        }
//
//                        HStack{
//                            Text("Category")
//                            Picker(selection: $user.selected_category,
//                                       label: Text("")) {
//                                ForEach(0..<user.category.count) {
//                                    Text(self.user.category[$0])
//                                        }
//                                }
//                                .onChange(of: user.selected_category) {_ in
//                                    self.user.isSendData = false
//                                    }
//                                .pickerStyle(SegmentedPickerStyle())
//                        }
//
//                        HStack{
//                            Text("APROP")
//                            Picker(selection: $user.selected_aprop,
//                                       label: Text("")) {
//                                ForEach(0..<user.aprop.count) {
//                                    Text(self.user.aprop[$0])
//                                        }
//                                }
//                                .onChange(of: user.selected_aprop) {_ in
//                                    self.user.isSendData = false
//                                    }
//                                .pickerStyle(SegmentedPickerStyle())
//                        }
//
//                        
//                        HStack{
//                            Text("自由記載欄")
//                            TextField("", text: $user.free_disease)
//                                .keyboardType(.default)
//                        }.layoutPriority(1)
//                        .onChange(of: user.free_disease) { _ in
//                        self.user.isSendData = false
//                        }
//                    }
//                    
//                    Section(header: Text("分類"), footer: Text("")){
//
//                        Image("area")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: geometry.size.width)
//                        
//                        Image("stage")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: geometry.size.width)
//                    }
                }.navigationTitle("患者情報入力")
                .onAppear(){
                }
            }
            }
            
    
                
            
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
               }
                
            ) {
                Text("保存")
                    .foregroundColor(Color.white)
                    .font(Font.largeTitle)
            }
                .frame(minWidth:0, maxWidth:CGFloat.infinity, minHeight: 75)
                .background(Color.black)
                .padding()
                .sheet(isPresented: self.$goTakePhoto) {
                    CameraPage(user: user)
                }
        
    }
}
