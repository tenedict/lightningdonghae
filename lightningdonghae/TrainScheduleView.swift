import SwiftUI

struct TrainScheduleView: View {
    @State private var departureStation: String = ""
    @State private var arrivalStation: String = ""
    @State private var nextTrainTimes: [String] = [] // 검색된 도착 시간을 저장할 배열
    @State private var travelTime: String? = nil // 소요 시간을 저장할 변수
    @State private var isSearching: Bool = false // 검색 중 상태를 나타냄
    @State private var errorMessage: String? = nil // 에러 메시지를 저장할 변수
    
    var body: some View {
        VStack {
            // 출발역 입력 필드
            TextField("출발역을 입력하세요", text: $departureStation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 도착역 입력 필드
            TextField("도착역을 입력하세요", text: $arrivalStation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 검색 버튼
            Button(action: {
                // 검색 중 상태로 설정
                isSearching = true
                searchTrainTimes()
            }) {
                if isSearching {
                    ProgressView() // 검색 중일 때 로딩 인디케이터
                        .padding()
                } else {
                    Text("검색")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isSearching || departureStation.isEmpty || arrivalStation.isEmpty) // 입력이 비어있거나 검색 중일 때 비활성화
            
            // 오류 메시지 출력
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top)
            }
            
            // 검색 결과를 텍스트로 출력
            if !nextTrainTimes.isEmpty {
                Text("가장 가까운 두 개의 열차 시간:")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(nextTrainTimes, id: \.self) { time in
                    Text(time)
                        .padding(.top, 2)
                }
            }
            
            // 소요 시간 출력
            if let travelTime = travelTime {
                Text("소요 시간: \(travelTime)")
                    .font(.headline)
                    .padding(.top, 10)
            }
        }
        .padding()
        .preferredColorScheme(.light)
    }
    
    // 도착 시간을 검색하는 함수
    func searchTrainTimes() {
        // 출발역과 도착역이 비어있으면 에러 메시지 설정
        guard !departureStation.isEmpty, !arrivalStation.isEmpty else {
            errorMessage = "출발역과 도착역을 입력하세요."
            isSearching = false
            return
        }
        
        // 에러 메시지 초기화
        errorMessage = nil
        
        // 열차 정보를 검색하고 상태 업데이트
        DispatchQueue.global().async {
            let result = getTrainInfo(departure: departureStation, arrival: arrivalStation)
            
            DispatchQueue.main.async {
                // 검색된 결과를 로그로 출력하여 확인
                print("검색된 열차 시간: \(result.nextTwoTrains)")
                print("소요 시간: \(String(describing: result.travelTime))")
                
                // 상태 변수를 업데이트
                nextTrainTimes = result.nextTwoTrains
                travelTime = result.travelTime
                
                // 검색 중 상태 해제
                isSearching = false
                
                // 검색 결과가 없을 경우 에러 메시지 설정
                if nextTrainTimes.isEmpty && travelTime == nil {
                    errorMessage = "해당 시간에 열차가 없습니다."
                }
            }
        }
    }
}

// SwiftUI Preview
struct TrainScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TrainScheduleView()
    }
}
