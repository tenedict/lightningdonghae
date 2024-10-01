import SwiftUI

// 역 리스트
let stations = [
    "부전", "거제해맞이", "거제", "부산교대", "동래", "안락", "부산원동",
    "재송", "센텀", "벡스코", "신해운대", "송정", "오시리아", "기장", "일광",
    "좌천", "월내", "서생", "남창", "망양", "덕하", "개운포", "태화강"
]

// 메인 화면: 역 리스트
struct SelectArrivalStation: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(Array(stations.enumerated()), id: \.offset) { index, station in
                        VStack {
                            HStack{
                                if index != 0 {
                                    DottedLine() // 원으로 된 두 개의 점선
                                        .frame(width: 4, height: 10)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 30)
                                }
                                Spacer()
                            }
                            NavigationLink(destination: EmptyView(station: station)) {
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 30, height: 30)
                                        .overlay(Text("\(index + 1)").foregroundColor(.white))
                                    
                                    Text("\(station)역")
                                        .font(.headline)
                                        .padding(.leading, 10)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color(red: 240/255, green: 248/255, blue: 255/255))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle("도착역 선택하기", displayMode: .inline)
        }
    }
}

// 엠프티 뷰: 선택한 역 이름을 표시
struct EmptyView: View {
    var station: String
    
    var body: some View {
        VStack {
            Text("\(station)역 정보가 없습니다.")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationBarTitle("\(station)역", displayMode: .inline)
    }
}

// 두 개의 원을 표시하는 점선 그리기 컴포넌트
struct DottedLine: View {
    var body: some View {
        VStack(spacing: 5) { // 원 사이의 간격을 조정
            Circle()
                .frame(width: 4, height: 4)
            Circle()
                .frame(width: 4, height: 4)
        }
    }
}

