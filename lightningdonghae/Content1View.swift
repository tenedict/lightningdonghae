//
//  Content1.swift
//  lightningdonghae
//
//  Created by 문재윤 on 10/2/24.
//
import SwiftUI

struct Content1View: View {
    @State private var currentTime = Date()  // 현재 시간을 저장하는 변수
    
    var body: some View {
        VStack {
            ForEach(subwaySchedules.keys.sorted(), id: \.self) { station in
                VStack {
                    Text(station)
                        .font(.headline)
                    
                    // 주말인지 평일인지에 따라 다른 시간표를 적용
                    if isWeekend() {
                        // 주말 시간표
                        if let nextUpTrain = nextTrainTime(from: subwaySchedules[station]?.weekendUp ?? [], currentTime: currentTime) {
                            Text("Weekend Up: Next train at \(nextUpTrain)")
                                .foregroundColor(.blue)
                        } else {
                            Text("Weekend Up: No more trains today")
                                .foregroundColor(.blue)
                        }
                        
                        if let nextDownTrain = nextTrainTime(from: subwaySchedules[station]?.weekendDown ?? [], currentTime: currentTime) {
                            Text("Weekend Down: Next train at \(nextDownTrain)")
                                .foregroundColor(.red)
                        } else {
                            Text("Weekend Down: No more trains today")
                                .foregroundColor(.red)
                        }
                    } else {
                        // 평일 시간표
                        if let nextUpTrain = nextTrainTime(from: subwaySchedules[station]?.weekdayUp ?? [], currentTime: currentTime) {
                            Text("Weekday Up: Next train at \(nextUpTrain)")
                                .foregroundColor(.blue)
                        } else {
                            Text("Weekday Up: No more trains today")
                                .foregroundColor(.blue)
                        }
                        
                        if let nextDownTrain = nextTrainTime(from: subwaySchedules[station]?.weekdayDown ?? [], currentTime: currentTime) {
                            Text("Weekday Down: Next train at \(nextDownTrain)")
                                .foregroundColor(.red)
                        } else {
                            Text("Weekday Down: No more trains today")
                                .foregroundColor(.red)
                        }
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
    
    // 다음 열차 시간을 찾는 함수 (현재 시간 이후의 가장 가까운 시간을 반환)
    func nextTrainTime(from schedule: [String], currentTime: Date) -> String? {
        for time in schedule {
            if let trainTime = stringToDate(time), trainTime > currentTime {
                return time
            }
        }
        return nil  // 남은 열차가 없으면 nil 반환
    }
    
    // 주말인지 판단하는 함수
    func isWeekend() -> Bool {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: today)
        
        // 주말인 경우 (토요일: 7, 일요일: 1)
        return components.weekday == 1 || components.weekday == 7
    }
}
#Preview {
    Content1View()
}
