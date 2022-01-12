//
//  Task.swift
//  CarApp (iOS)
//
//  Created by 盧彥甫 on 2022/1/2.
//

import SwiftUI

struct Task: Identifiable{
    var id: Int
    var title: String
    var carNo: String
    var time: Date = Date()
    var timeFloat: CGFloat
}

struct TaskMetaData: Identifiable{
    var id: Int
    var task: [Task]
    var taskDate: Date
}

func getSampleDate(offset: Int) -> Date{
    let calender = Calendar.current
    
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [TaskMetaData] = [
    TaskMetaData(id: 1, task: [
        Task(id: 1, title: "冷氣維修", carNo: "Z006", timeFloat: 1200),
        Task(id: 2, title: "水龍頭維修", carNo: "X013", timeFloat: 2400),
        Task(id: 3, title: "車輛維修：噴油嘴", carNo: "Z023", timeFloat: 4500)
    ], taskDate: getSampleDate(offset: 1)),
    TaskMetaData(id: 2, task: [
        Task(id: 4, title: "冷媒更換", carNo: "B034", timeFloat: 3400)
    ], taskDate: getSampleDate(offset: -3)
    ),
    TaskMetaData(id: 3, task: [
        Task(id: 5, title: "冷氣維修", carNo: "A047", timeFloat: 5600),
        Task(id: 6, title: "水管疏通", carNo: "A011", timeFloat: 7800)
    ], taskDate: getSampleDate(offset: 20)),
    TaskMetaData(id: 4, task: [
        Task(id: 7, title: "冷氣維修", carNo: "B047", timeFloat: 3400)
    ], taskDate: getSampleDate(offset: 4)
    ),
    TaskMetaData(id: 5, task: [
        Task(id: 8, title: "冷氣維修", carNo: "S033", timeFloat: 3400)
    ], taskDate: getSampleDate(offset: -13)
    ),
    TaskMetaData(id: 6, task: [
        Task(id: 9, title: "冷氣維修", carNo: "X044", timeFloat: 3400)
    ], taskDate: getSampleDate(offset: -16)
    ),
    TaskMetaData(id: 7, task: [
        Task(id: 10, title: "冷氣維修", carNo: "D055", timeFloat: 3400)
    ], taskDate: getSampleDate(offset: 9)
    ),
    TaskMetaData(id: 8, task: [
        Task(id: 11, title: "冷氣維修", carNo: "Z025", timeFloat: 3400)
    ], taskDate: getSampleDate(offset: 27)
    ),
]
