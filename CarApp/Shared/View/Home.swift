//
//  Home.swift
//  CarApp (iOS)
//
//  Created by 盧彥甫 on 2022/1/1.
//

import SwiftUI
import AVKit

struct Home: View {
    
    @State var currentDate: Date = Date()
    
    @State var isCompleted: Bool = false
    
    @State var itemId: Int = 0
    
    @State var isAddFixTask: Bool = false
    
    @State var showDashboard: Bool = false
    
    let api = API()
    
    @ObservedObject var soundManager = SoundManager()
    
    var body: some View {
        
        
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                //Custome Date Picker
                CustomDatePicker(currentDate: $currentDate, isCompleted: $isCompleted, itemId: $itemId, isAddFixTask: $isAddFixTask)
            }
            .padding(.vertical)
            .onAppear {
                //新增維修行程
                addFixTask()
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack{
                Button{

                    addFixTasktwo()

                } label: {
                    Text("Contact")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.darkGray), in: Capsule())
                }

                Button{
                    self.showDashboard = true
                } label: {
                    Text("Dashboard")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.darkGray), in: Capsule())
                }.sheet(isPresented: $showDashboard) {
                    Dashboard()
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
            .buttonStyle(FlatLinkStyle())
            .shadow(color: .gray, radius: 2, x: 0, y: 3)
        }
    }
    
    //update task card background color when api send true response
    func completeTask(){
        self.itemId += 1
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            completeRequest()
            if isCompleted == true{
                timer.invalidate()
            }
        }
    }
    
    func completeRequest(){
        
        let url = "https://automation-backend-server.herokuapp.com/schedule"
        
        var request = URLRequest(url: URL(string:url)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
                    print(content)
                    if content == "1" {
                        self.isCompleted = true
                        
                    }
//                    else {
//                        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
//                            self.sendTextRequest()
//                            timer.invalidate()
//                        }
//                    }
//                }
            }
        }.resume()
    }
    
    func addFixTask(){
        
        let url = "https://automation-backend-server.herokuapp.com/iphone"
        
        var request = URLRequest(url: URL(string:url)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(content)
                    if content == "1" {
                        self.isAddFixTask = true
                        
                        soundManager.playSound()
                        
                        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                            let sms = "sms:+886939998093&body=預約車輛維修\n車輛資訊：中華汽車Veryca\n車輛維修事項：傳動皮帶維修\n預約時間：2021/01/07 18:00"
                            let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                            timer.invalidate()
                        }
                    }
                    else {
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                            print("retry addFixTask: \(content)")
                            self.addFixTask()
                            timer.invalidate()
                        }
                    }
                }
            }
        }.resume()
    }
    
    func addFixTasktwo(){
        
        isAddFixTask = true
        soundManager.playSound()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            let sms = "sms:+886939998093&body=預約車輛維修\n車輛資訊：中華汽車VeryCa\n車輛維修事項：傳動皮帶維修\n預約時間：2021/01/07 18:00"
            let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            timer.invalidate()
        }
        
    }
    
    
}

class SoundManager: ObservableObject {
    
    var player: AVAudioPlayer?
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "sound", withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        catch let error{
            print("error playing sound: \(error)")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
