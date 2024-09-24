//
//  Untitled.swift
//  lightningdonghae
//
//  Created by 문재윤 on 9/24/24.
//
import SwiftUI

struct SubwayMapView: View {
    
    // 동해선 역 목록
    let stations = [
        "부전", "거제해맞이", "거제", "부산교대", "동래", "안락", "부산원동",
        "재송", "센텀", "벡스코", "신해운대", "송정", "오시리아", "기장", "일광",
        "좌천", "월내", "서생", "남창", "망양", "덕하", "개운포", "태화강"
    ]
    
    // 각 역을 S자 형태로 배치하는 좌표
    let stationCoordinates: [CGPoint] = [
        CGPoint(x: 40, y: 100), CGPoint(x: 140, y: 100), CGPoint(x: 240, y: 100),
        CGPoint(x: 340, y: 100), CGPoint(x: 340, y: 180), CGPoint(x: 240, y: 180),
        CGPoint(x: 140, y: 180), CGPoint(x: 40, y: 180), CGPoint(x: 40, y: 260),
        CGPoint(x: 140, y: 260), CGPoint(x: 240, y: 260), CGPoint(x: 340, y: 260),
        CGPoint(x: 340, y: 340), CGPoint(x: 240, y: 340), CGPoint(x: 140, y: 340),
        CGPoint(x: 40, y: 340), CGPoint(x: 40, y: 420), CGPoint(x: 140, y: 420),
        CGPoint(x: 240, y: 420), CGPoint(x: 340, y: 420), CGPoint(x: 340, y: 500),
        CGPoint(x: 190, y: 500), CGPoint(x: 40, y: 500)
    ]
    
    @State private var selectedStation: String? = nil
    @State private var nextTrainTimes: (Int, Int)? = nil // 다음 열차와 부전행, 태화강행 시간
    @State private var showInfo: Bool = false // 정보를 표시할지 여부
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack {
                    // 파란색 노선 그리기
                    Path { path in
                        path.move(to: stationCoordinates.first!)
                        for point in stationCoordinates {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.blue, lineWidth: 4)
                    
                    // 각 역을 버튼으로 표시
                    ForEach(Array(stations.enumerated()), id: \.element) { index, station in
                        let coordinate = stationCoordinates[index]
                        Button(action: {
                            // 역을 클릭했을 때 배차 정보를 표시
                            selectedStation = station
                            nextTrainTimes = calculateNextTrainTimes()
                            showInfo = true
                        }) {
                            Text(station)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        .position(x: coordinate.x, y: coordinate.y)
                    }
                }
//                .frame(minHeight: 1300) // 전체 뷰 크기 설정
            }
            
            // 정보 박스
            if showInfo, let station = selectedStation, let times = nextTrainTimes {
                VStack {
                    Text(station)
                        .font(.headline)
                        .padding(10)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    
                    HStack {
                        VStack {
                            Text("태화강행")
                            Text("\(times.0) 분 후")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        
                        VStack {
                            Text("부전행")
                            Text("\(times.1) 분 후")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
                .padding()
            }
        }
    }
    
    // 현재 시간에 따른 다음 열차 도착 시간을 계산하는 함수
    func calculateNextTrainTimes() -> (Int, Int) {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMinute = calendar.component(.minute, from: currentDate)
        
        // 10분 단위로 배차된 시간표를 기준으로 계산
        let minutesUntilNextTrain = 10 - (currentMinute % 10)
        
        // 부전행과 태화강행 열차 도착 시간
        let minutesUntilBujeon = minutesUntilNextTrain
        let minutesUntilTaehwagang = minutesUntilNextTrain + 5 // 예시로 5분 후 도착
        
        return (minutesUntilNextTrain, minutesUntilTaehwagang)
    }
}

#Preview {
    SubwayMapView()
}
