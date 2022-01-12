//
//  API.swift
//  CarApp (iOS)
//
//  Created by 盧彥甫 on 2022/1/2.
//

import Foundation
import SwiftUI

struct API {

    func phoneCallRequest() {
        
        let url = "https://automation-backend-server.herokuapp.com/iphone"

        var request = URLRequest(url: URL(string:url)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error occure while making phone call: \(error)")
            }
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(content)
                    if content == "1" {
                        
                        let sms = "sms:+886921596505&body=道路救援通知"
                        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)

                        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                            if let callUrl = URL(string: "tel://\(0921596505)"), UIApplication.shared.canOpenURL(callUrl) {
                                UIApplication.shared.open(callUrl)
                            }
                        }
                        
                        
                        
                    }
//                    else {
//                        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
//                            self.phoneCallRequest()
//                            timer.invalidate()
//                        }
//                    }
                }
            }
        }.resume()
    }
    
    func sendTextRequest() {
        
        let url = "https://automation-backend-server.herokuapp.com/iphone"

        var request = URLRequest(url: URL(string:url)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(content)
                    if content == "true" {

                        let sms = "sms:+886921596505&body=預約車輛維修\n車輛資訊：中華汽車VeryCar\n車輛維修事項：噴油嘴維修\n預約時間：2021/01/07 18:00"
                        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                    }
//                    else {
//                        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
//                            self.sendTextRequest()
//                            timer.invalidate()
//                        }
//                    }
                }
            }
        }.resume()
    }
    
    func sendText() {
        let sms = "sms:+886963070901&body=預約車輛維修\n車輛資訊：中華汽車VeryCar\n車輛維修事項：噴油嘴維修\n預約時間：2021/01/07 18:00"
        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    
}
