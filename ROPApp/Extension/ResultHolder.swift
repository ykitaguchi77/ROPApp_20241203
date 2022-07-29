//
//  ResultHolder.swift
//  CorneaApp
//
//  Created by Yoshiyuki Kitaguchi on 2021/04/19.
//  Created by Kuniaki Ohara on 2021/01/30.
//
import SwiftUI

class ResultHolder{
    init() {}
    
    // インスタンスを保持する必要はなく、すべてのインスタンス変数をstaticにする実装で良いと思います。
    static var instance: ResultHolder?
    public static func GetInstance() -> ResultHolder{
        if (instance == nil) {
            instance = ResultHolder()
        }
        
        return instance!
    }

 
 
    private (set) public var Images: [Int:CGImage] = [:]
    private (set) public var MovieUrl: String = ""
    
    public func GetUIImages() -> [UIImage]{
        var uiImages: [UIImage] = []
        let length = Images.count
        for i in 0 ..< length {
            if (Images[i] != nil){
                uiImages.append(UIImage(cgImage: Images[i]! ))
            }
        }
        
        return uiImages
    }
    
    public func SetImage(index: Int, cgImage: CGImage){
        Images[index] = cgImage
    }
    
    
    
    public func SetMovieUrls(Url:String){
        print(MovieUrl)
        MovieUrl = Url
    }
    
    public func GetMovieUrls() ->String{
        let Url = MovieUrl
        return Url
    }
    
    
    
    public func GetImageJsons() -> [String]{
        var imageJsons:[String] = []
        let uiimages = GetUIImages()
        let jsonEncoder = JSONEncoder()
        let length = uiimages.count
        for i in 0 ..< length {
            if (Images[i] != nil){
                let data = PatientImageData()
                
                data.image = uiimages[i].resize(size: ConstHolder.EVALIMAGESIZE)!.pngData()!.base64EncodedString()
                let jsonData = (try? jsonEncoder.encode(data)) ?? Data()
                let json = String(data: jsonData, encoding: String.Encoding.utf8)!
                imageJsons.append(json)
            }
        }
        
        return imageJsons
    }
    
    private (set) public var Answers: [String:String] = ["q1":"", "q2":"", "q3":"", "q4":"", "q5": "", "q6": "", "q7": "", "q8": "", "q9": "" , "q10": "" , "q11": "", "q12": "", "q13": "", "q14": "", "q15": ""]

    public func SetAnswer(q1:String, q2:String, q3:String, q4:String, q5:String, q6:String, q7:String, q8:String, q9:String, q10:String, q11:String, q12:String, q13:String, q14:String, q15:String){
        Answers["q1"] = q1 //date
        Answers["q2"] = q2 //hashID
        Answers["q3"] = q3 //ID
        Answers["q4"] = q4 //birthdate
        Answers["q5"] = q5 //gestational Week
        Answers["q6"] = q6 //gender
        Answers["q7"] = q7 //hospital
        Answers["q8"] = q8 //imgNum
        Answers["q9"] = q9 //side
        Answers["q10"] = q10 //zone
        Answers["q11"] = q11 //stage
        Answers["q12"] = q12 //plusDisease
        Answers["q13"] = q13 //category
        Answers["q14"] = q14 //aprop
        Answers["q15"] = q15 //free
    }
    
    public func GetAnswerJson() -> String{
        let data = QuestionAnswerData()
        data.pq1 = Answers["q1"] ?? ""
        data.pq2 = Answers["q2"] ?? ""
        data.pq3 = Answers["q3"] ?? ""
        data.pq4 = Answers["q4"] ?? ""
        data.pq5 = Answers["q5"] ?? ""
        data.pq6 = Answers["q6"] ?? ""
        data.pq7 = Answers["q7"] ?? ""
        data.pq8 = Answers["q8"] ?? ""
        data.pq9 = Answers["q9"] ?? ""
        data.pq10 = Answers["q10"] ?? ""
        data.pq11 = Answers["q11"] ?? ""
        data.pq12 = Answers["q12"] ?? ""
        data.pq13 = Answers["q13"] ?? ""
        data.pq14 = Answers["q14"] ?? ""
        data.pq15 = Answers["q15"] ?? ""
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        let jsonData = (try? jsonEncoder.encode(data)) ?? Data()
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        return json
    }
}

class PatientImageData: Codable{
    var image = ""
}

class QuestionAnswerData: Codable{
    var pq1 = ""
    var pq2 = ""
    var pq3 = ""
    var pq4 = ""
    var pq5 = ""
    var pq6 = ""
    var pq7 = ""
    var pq8 = ""
    var pq9 = ""
    var pq10 = ""
    var pq11 = ""
    var pq12 = ""
    var pq13 = ""
    var pq14 = ""
    var pq15 = ""
}
