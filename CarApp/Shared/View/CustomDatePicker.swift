//
//  CustomDatePicker.swift
//  CarApp (iOS)
//
//  Created by 盧彥甫 on 2022/1/1.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    //Month update on arrow button clicks
    @State var currentMonth: Int = 0
    
    //Task status
    @Binding var isCompleted: Bool
    
    @Binding var itemId: Int
    
    @Binding var isAddFixTask: Bool
    
    //Task element
    
    let api = API()
    
    var body: some View {
        
        VStack(spacing: 20){
            
            HStack(){
                
                Spacer()
                    .frame(width: 135, height: 1)
                
                Capsule()
                    .size(width: 170, height: 70)
                    .foregroundColor(Color.pink)
                    .opacity(0.3)
                    .overlay(
                        HStack(spacing: 2){
                            VStack(){
                                Text("Wellcome")
                                    .font(.system(size: 20))
                                    .fontWeight(.ultraLight)
                                Text("阿宏   ")
                                    .font(.system(size: 32))
                                    .fontWeight(.black)
                            }
                            .padding(.top, 60)
                            

                            Image("wu")
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                                .clipShape(Circle().size(width: 60, height: 60))
                                .padding(.top, 60)
                        }
                    )
                    .padding(.leading, 100)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
                
                    
            }
            .padding(.top,-20)
            
            Spacer()
            
            //Days
            let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            HStack(spacing: 20){
                
                
                VStack(alignment: .leading , spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
//                Button{
//                    api.sendText()
//                } label: {
//                    Text("")
//                        .frame(width: 20, height: 20)
//                        .background(Color(UIColor.clear))
//                }
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            //Day View
            
            HStack(spacing: 0){
                ForEach(days,id: \.self){day in
                    
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //Dates
            //Lazy Grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in

                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color(UIColor.systemPink))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                                .frame(minWidth: 55)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            VStack(spacing: 15){
                Text("Schedule")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: currentDate)
                }) {
                    ForEach(task.task) { task in
                        VStack(alignment: .leading, spacing: 10) {

                            Text(
                                task.time
                                    .addingTimeInterval(CGFloat(task.timeFloat * CGFloat(task.id))), style: .time)
                            
                            HStack(){
                                
                                Text(task.title)
                                    .font(.title2.bold())
                                
//                                Text(task.carNo)
//                                    .font(Font.footnote.bold())
//                                    .underline()
                                
                                if isCompleted && task.id <= itemId {
                                    Image(systemName: "checkmark.circle").foregroundColor(.green)
                                }
                                else{
                                    if task.id == 3 {
                                        Image(systemName: "gearshape.2").foregroundColor(.yellow)
                                    }
                                    else{
                                        Image(systemName: "car.circle").foregroundColor(.red)
                                    }
                                    
                                }
                            }
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(task.id == 3
                                    ? LinearGradient(gradient: Gradient(colors: [.yellow, .white]), startPoint: UnitPoint.topLeading, endPoint: UnitPoint.bottomTrailing).opacity(0.4)
                                        .cornerRadius(10):
                                        LinearGradient(gradient: Gradient(colors: [.pink, .white]), startPoint: UnitPoint.topLeading, endPoint: UnitPoint.bottomTrailing)
                            .opacity(0.4)
                            .cornerRadius(10)
                        )
                        .opacity(task.id == 3 && !isAddFixTask ? 0 : 1)
                    }
                }
                else {
                    Text("No Task Found")
                }
            }
            .padding()
            .padding(.top, 20)
        }
        .onChange(of: currentMonth) { newValue in
            //updating Month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack{
            if value.day != -1{
                if let task = tasks.first(where: { task in
                    
                    return isSameDay(date1: task.taskDate, date2: value.date)
                })
                {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : Color(UIColor.systemPink))
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : Color(UIColor.systemPink))
                        .frame(width: 8, height: 8)
                }
                else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    
    //checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    //extracting Year and Month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date{
        let calendar = Calendar.current
        
        //getting current Month Date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date())
        else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue]{
        let calendar = Calendar.current
        
        //getting current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            //getting day
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        //adding offset days to get exact week day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    
    }
    
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date{
    func getAllDates() -> [Date]{
        
        let calendar = Calendar.current
        
        //getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        //getting date
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
            
        }
    }
}
