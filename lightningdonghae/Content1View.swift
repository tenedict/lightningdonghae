//
//  Content1.swift
//  lightningdonghae
//
//  Created by 문재윤 on 10/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTime = Date()  // 현재 시간을 저장하는 변수
    
    // 각 역의 시간표 저장
    let subwaySchedules: [String: [String]] = [
        "Astation": ["05:20:00", "05:24:00", "05:31:30", "06:00:00"],
        "Bstation": ["05:15:00", "05:25:00", "05:35:00", "05:55:00"],
        "Cstation": ["05:18:00", "05:28:00", "05:38:00", "06:05:00"]
    ]
    
    var body: some View {
        VStack {
            ForEach(subwaySchedules.keys.sorted(), id: \.self) { station in
                VStack {
                    Text(station)
                        .font(.headline)
                    
                    if let nextTime = nextTrainTime(from: subwaySchedules[station] ?? [], currentTime: currentTime) {
                        Text("Next train at: \(nextTime)")
                    } else {
                        Text("No more trains today")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // 1분마다 현재 시간 갱신
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                self.currentTime = Date()
            }
        }
    }
    
    // String을 Date로 변환하여 비교하는 함수
    func stringToDate(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let today = Date()
        let calendar = Calendar.current
        
        // 현재 날짜에 해당하는 시간으로 Date 객체 생성
        if let timeDate = formatter.date(from: timeString) {
            let components = calendar.dateComponents([.year, .month, .day], from: today)
            let newDate = calendar.date(bySettingHour: calendar.component(.hour, from: timeDate),
                                        minute: calendar.component(.minute, from: timeDate),
                                        second: calendar.component(.second, from: timeDate),
                                        of: today)
            return newDate
        }
        return nil
    }
    
    // 다음 열차 시간을 찾는 함수
    func nextTrainTime(from schedule: [String], currentTime: Date) -> String? {
        for time in schedule {
            if let trainTime = stringToDate(time), trainTime > currentTime {
                return time
            }
        }
        return nil  // 남은 열차가 없으면 nil 반환
    }
}
#Preview {
    Content1View()
}
