//
//  Dashboard.swift
//  CarApp (iOS)
//
//  Created by 盧彥甫 on 2022/1/9.
//

import SwiftUI
import SwiftUICharts

struct Dashboard: View {
    
    @State var progress: Double = 0.01
    
    var data = [35, 60]
    
    var color = [Color("Color1"), Color("Color1")]
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                LineChartsFull()
                    .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 2)
                
                BarCharts()
                    .frame(width: UIScreen.main.bounds.width - 10, height: 130)
                    .offset(y: -15)
                
                LazyVGrid(columns: columns, spacing: 30) {
                    
                    ForEach(stats_Data){ stat in
                        
                        VStack(spacing:22){
                            
                            HStack{
                                Text(stat.title)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Spacer(minLength: 0)
                            }
                            
                            //Ring
                            ZStack{
                                Circle()
                                    .trim(from: 0, to: (stat.currentData / stat.goal))
                                    .stroke(getCircleColor(per: Double(stat.currentData / stat.goal) * 100.0), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Text(getPrecent(current:stat.currentData, goal: stat.goal) + "%")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(getHealthColor(per: Double(stat.currentData / stat.goal) * 100.0))
                                    .rotationEffect(.init(degrees: 90))
                                    .frame(width: 60)
                                    .offset(x: 35)
                                    .overlay(
                                        Image("\(stat.imageName)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .rotationEffect(.init(degrees: 90))
                                            //.edgesIgnoringSafeArea(.top)
                                    )
                                
                                
    //                                .padding(.top, 60)
                            }
                            .rotationEffect(.init(degrees: -90))
                        }
                        .padding()
                        .background(Color.white.opacity(0.92))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 0)
                    }
                }
            }
        }
    }
    
    func getPrecent(current: CGFloat, goal: CGFloat) -> String{
        let per = (current / goal) * 100
        
        return String(format: "%.0f", per)
    }
    
    func getHealthColor(per: Double) -> Color{
        var color = Color.gray
        
        switch per {
        case 0.0...20.0:
            color = Color.red
        case 21.0...60.0:
            color = Color.orange
        case 61.0...80.0:
            color = Color.mint
        case 81.0...100.0:
            color = Color.green
        default:
            color = Color.gray
        }
        
        return color
    }
    
    func getCircleColor(per: Double) -> AngularGradient{
        var color = AngularGradient(colors: [.white], center: .center)
        
        switch per {
        case 0.0...20.0:
            color = AngularGradient(gradient: Gradient(colors: [.red, .pink]), center: .center, startAngle: .degrees(45), endAngle: .degrees(0))
        case 21.0...60.0:
            color = AngularGradient(gradient: Gradient(colors: [.orange, .yellow]), center: .center, startAngle: .degrees(180), endAngle: .degrees(0))
        case 61.0...80.0:
            color = AngularGradient(gradient: Gradient(colors: [.mint, .blue]), center: .center, startAngle: .degrees(270), endAngle: .degrees(0))
        case 81.0...100.0:
            color = AngularGradient(gradient: Gradient(colors: [.green]), center: .center, startAngle: .degrees(180), endAngle: .degrees(0))
        default:
            color = AngularGradient(colors: [.gray], center: .center)
        }
        
        return color
    }
    
    func getCircleGradient(color: Color) ->AngularGradient{
        let gradient = AngularGradient(gradient: Gradient(colors: [color, .purple]), center: .center, startAngle: .degrees(340), endAngle: .degrees(0))
        
        return gradient
    }
}

struct LineChartsFull: View {
    var body: some View {
        VStack{
            let chartStyle = ChartStyle(backgroundColor: Color.white.opacity(0.3), accentColor: Colors.GradientPurple, secondGradientColor: Colors.GradientNeonBlue, textColor: Color.black, legendTextColor: Color.gray, dropShadowColor: Color.black.opacity(0.1))
            
            LineView(data: [25,22,28,25,25,20,28,31,22,23,25], title: "油耗量", legend: "檢測結果：正常", style: chartStyle).padding()
            // legend is optional, use optional .padding()
        }
    }
}

struct BarCharts:View {
    var body: some View {
        VStack{
            
            BarChartView(data: ChartData(points: [8,23,28,32,20,12,37,34,15,18,23,28,30,43]), title: "里程數",style: Styles.barChartStyleOrangeLight, form: CGSize(width: UIScreen.main.bounds.width - 10, height: 130), dropShadow: false)
                
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}

struct Stats: Identifiable {
    var id: Int
    var title: String
    var currentData: CGFloat
    var goal: CGFloat
    var imageName: String
}

var stats_Data = [
    Stats(id: 0, title: "電瓶", currentData: 6.8, goal: 10, imageName: "battery"),
    Stats(id: 1, title: "避震器", currentData: 9.5, goal: 10, imageName: "damper"),
    Stats(id: 2, title: "引擎", currentData: 4.6, goal: 10, imageName: "engine"),
    Stats(id: 3, title: "傳動皮帶", currentData: 1.9, goal: 10, imageName: "engine1"),
    Stats(id: 4, title: "油箱", currentData: 7.3, goal: 10, imageName: "oil"),
    Stats(id: 5, title: "活塞", currentData: 5.5, goal: 10, imageName: "piston"),
    Stats(id: 6, title: "方向盤", currentData: 3.6, goal: 10, imageName: "steering-wheel"),
    Stats(id: 7, title: "輪胎", currentData: 7.8, goal: 10, imageName: "tire"),
    Stats(id: 8, title: "水箱", currentData: 8.3, goal: 10, imageName: "water"),
]
