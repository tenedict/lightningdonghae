import SwiftUI
import CoreLocation

// 관광지 정보를 담을 구조체
struct TouristSpot: Identifiable {
    let id: UUID = UUID()  // 각 관광지 정보의 고유 ID
    let name: String
    let latitude: Double
    let longitude: Double
    let address: String
    let nearestSubway: String
    let description: String
    let imageURL: String  // 사진 URL 추가
}

// 샘플 관광지 데이터를 배열로 생성
let touristSpots = [
    TouristSpot(name: "경복궁", latitude: 37.579617, longitude: 126.977041, address: "서울특별시 종로구 세종로 1-1", nearestSubway: "경복궁역", description: "조선시대의 궁궐로서 역사적 가치가 높은 유적지입니다.", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJsPLZoRZuH-0NDKlI_esDNY7LmwSCElb6pQ&s"),
    TouristSpot(name: "남산서울타워", latitude: 37.551169, longitude: 126.988226, address: "서울특별시 용산구 남산공원길 105", nearestSubway: "명동역", description: "서울을 대표하는 랜드마크로 서울 시내 전경을 한눈에 볼 수 있습니다.", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Seoul_Tower_%284394893276%29.jpg/550px-Seoul_Tower_%284394893276%29.jpg"),
    TouristSpot(name: "롯데월드", latitude: 37.511034, longitude: 127.098034, address: "서울특별시 송파구 올림픽로 240", nearestSubway: "잠실역", description: "세계 최대의 실내 놀이공원으로 다양한 즐길거리를 제공합니다.", imageURL: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Khitai7.jpg")
]

struct TourlistView: View {
    @State private var searchText = ""  // 검색어 저장하는 상태 변수
       
       var body: some View {
           NavigationView {
               List(filteredTouristSpots) { spot in
                   TouristSpotCard(spot: spot)  // 각 관광지 정보를 카드 형식으로 표현
               }
               .searchable(text: $searchText, prompt: "관광지를 검색하세요")  // 서치바 추가
               .navigationTitle("검색결과")
           }
       }
       
       // 검색어를 기준으로 필터링된 관광지 리스트 반환
       var filteredTouristSpots: [TouristSpot] {
           if searchText.isEmpty {
               return touristSpots
           } else {
               return touristSpots.filter { spot in
                   spot.name.contains(searchText) || spot.address.contains(searchText)
               }
           }
       }
}

struct TouristSpotCard: View {
    let spot: TouristSpot
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {  // 전체 카드 구조
            HStack(spacing: 10) {  // 사진과 텍스트를 나란히 배치
                // 비동기적으로 이미지를 로드하고 표시
                AsyncImage(url: URL(string: spot.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)  // 이미지 크기 설정
                        .cornerRadius(10)
                } placeholder: {
                    // 로딩 중일 때 또는 오류가 있을 때의 플레이스홀더
                    ProgressView()
                        .frame(width: 120, height: 120)  // 이미지 공간 예약
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(spot.nearestSubway)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(spot.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(spot.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
            }
            
            HStack {
                Spacer()
                // 경로 찾기 버튼
                Button(action: {
                    // 경로 찾기 액션 추가
                    print("경로 찾기 버튼 클릭됨")
                }) {
                    Text("경로")
                        .padding()
                        .background(Color.blue)  // 버튼 배경색
                        .foregroundColor(.white)  // 버튼 텍스트 색
                        .cornerRadius(8)  // 모서리 둥글게
                }
                .padding(.horizontal)  // 버튼의 양쪽 여백
            }
           
          
        }
        .background(Color.white)
        .cornerRadius(10)

        .padding()
    }
}


#Preview {
    TourlistView()
}
