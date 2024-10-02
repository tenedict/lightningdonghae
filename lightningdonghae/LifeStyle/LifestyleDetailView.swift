//
//  Untitled.swift
//  lightningdonghae
//
//  Created by 문재윤 on 9/24/24.
//
import SwiftUI

// 라이프스타일을 선택한 후 나오는 상세화면
struct LifestyleDetailView: View {
    let lifestyleCategories = [
        "러닝", "자전거", "맛집", "힐링", "카페", "액티비티", "예술", "쇼핑", "문화", "역사",
        "자연", "건축물", "공원", "해변", "등산", "요가", "피트니스", "사진", "야경", "음악",
        "박물관", "극장", "전시회", "레저", "낚시", "수상 스포츠", "골프", "클럽", "스파", "온천"
    ]
    
    @State private var selectedCategory: String? = nil // 사용자가 선택한 라이프스타일 카테고리
    
    var body: some View {
        VStack {
            // AI 검색바 (기능 없이 UI만 구현)
            SearchBarView()
                .padding()
            
            // 라이프스타일 카테고리 리스트
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                    ForEach(lifestyleCategories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category // 선택한 카테고리를 저장
                        }) {
                            Text("#\(category)")
                                .frame(width: 100, height: 100)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            

        }
    }
}

// AI 검색바 뷰
struct SearchBarView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        HStack {
            TextField("관광지를 검색하세요...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
