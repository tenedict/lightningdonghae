import Foundation

// 시간을 처리하는 함수 (H:mm:ss 또는 HH:mm:ss 형식을 모두 처리)
func parseTimeString(_ timeString: String) -> Date? {
    let inputFormatter = DateFormatter()
    inputFormatter.timeZone = TimeZone.current
    
    // H:mm:ss 형식 처리
    inputFormatter.dateFormat = "H:mm:ss"
    if let date = inputFormatter.date(from: timeString) {
        return date
    }
    
    // HH:mm:ss 형식 처리
    inputFormatter.dateFormat = "HH:mm:ss"
    return inputFormatter.date(from: timeString)
}

// 1. CSV 파일 불러오기 (첫 번째 ~ 세 번째 행 제외, 네 번째 행부터 시작)
// CSV 파일을 로드하고 처리하는 함수
func loadCSV(fileName: String) -> [[String: String]]? {
    guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
        print("CSV 파일 경로를 찾을 수 없습니다.")
        return nil
    }
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let csv = content.split(separator: "\n").map { $0.split(separator: ",").map { String($0) } }
        
        // 첫 번째 행은 출발역, 두 번째 행은 도착역, 세 번째 행은 열차번호
        guard csv.count > 3 else {
            print("CSV 파일의 행 수가 부족합니다.")
            return nil
        }

        let stations = csv[3...].map { row -> [String: String] in
            var stationData = [String: String]()
            for (index, value) in row.enumerated() {
                let key = index % 2 == 0 ? "도착" : "출발"
                stationData[key] = value
            }
            return stationData
        }

        print("CSV 파일이 정상적으로 로드되었습니다: \(fileName)")
        return stations
    } catch {
        print("CSV 파일을 불러오는 중 에러 발생: \(error)")
        return nil
    }
}

// 2. 평일/주말 구분 함수
func isWeekend() -> Bool {
    let calendar = Calendar.current
    let today = Date()
    return calendar.isDateInWeekend(today)
}

// 3. 상행/하행 구분 함수
func isUpLine(departure: String, arrival: String, stations: [String]) -> Bool {
    if let departureIndex = stations.firstIndex(of: departure),
       let arrivalIndex = stations.firstIndex(of: arrival) {
        return departureIndex < arrivalIndex
    }
    return false
}

// 4. 가까운 두 개의 열차 시간 찾기 함수
func findNextTwoTrainTimes(departure: String, timetable: [[String: String]]) -> [String] {
    let currentTime = Date()
    let outputFormatter = DateFormatter()
    outputFormatter.timeZone = TimeZone.current
    outputFormatter.dateFormat = "HH:mm:ss"
    
    let futureTrains = timetable.compactMap { (row: [String: String]) -> Date? in
        if let timeString = row["출발"], !timeString.isEmpty, let trainTime = parseTimeString(timeString) {
            if trainTime > currentTime {
                return trainTime
            }
        }
        return nil
    }
    
    let sortedTrainTimes = futureTrains.sorted().prefix(2).map { outputFormatter.string(from: $0) }
    return Array(sortedTrainTimes)
}

// 5. 소요 시간 계산 함수
func calculateTravelTime(departure: String, arrival: String, timetable: [[String: String]]) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss" // 시간 형식 지정
    dateFormatter.timeZone = TimeZone.current
    
    if let departureRow = timetable.first(where: { $0["출발"] != nil }),
       let arrivalRow = timetable.first(where: { $0["도착"] != nil }),
       let departureTimeString = departureRow["출발"],
       let arrivalTimeString = arrivalRow["도착"],
       let departureTime = parseTimeString(departureTimeString),
       let arrivalTime = parseTimeString(arrivalTimeString) {
        
        let travelTime = arrivalTime.timeIntervalSince(departureTime)
        let minutes = Int(travelTime / 60)
        return "\(minutes)분 소요"
    }
    return nil
}

// 6. 전체 흐름 함수
func getTrainInfo(departure: String, arrival: String) -> (nextTwoTrains: [String], travelTime: String?) {
    // 역 리스트 예시 (실제 역 이름으로 변경)
    let stations = ["StationA", "StationB", "StationC", "StationD"]
    
    // CSV 파일 불러오기
    let weekdayUpData = loadCSV(fileName: "평일상행") ?? []
    let weekdayDownData = loadCSV(fileName: "평일하행") ?? []
    let weekendUpData = loadCSV(fileName: "휴일상행") ?? []
    let weekendDownData = loadCSV(fileName: "휴일하행") ?? []
    
    // 주말 확인
    let weekend = isWeekend()
    
    // 상행/하행 결정
    let upLine = isUpLine(departure: departure, arrival: arrival, stations: stations)
    
    // 알맞은 시간표 선택
    var selectedTimetable: [[String: String]] = []
    
    if weekend {
        selectedTimetable = upLine ? weekendUpData : weekendDownData
    } else {
        selectedTimetable = upLine ? weekdayUpData : weekdayDownData
    }
    
    // 가까운 두 개의 열차 시간
    let nextTwoTrains = findNextTwoTrainTimes(departure: departure, timetable: selectedTimetable)
    
    // 소요 시간 계산
    let travelTime = calculateTravelTime(departure: departure, arrival: arrival, timetable: selectedTimetable)
    
    return (nextTwoTrains, travelTime)
}
// 7. 함수 호출 예시
//let result = getTrainInfo(departure: "StationA", arrival: "StationC")
//print("다음 두 열차 시간: \(result.nextTwoTrains)")
//print("소요 시간: \(result.travelTime ?? "소요 시간 정보를 찾을 수 없습니다.")")
