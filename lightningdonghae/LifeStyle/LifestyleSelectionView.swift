//
//  LifestyleSelectionView.swift
//  lightningdonghae
//
//  Created by 문재윤 on 9/24/24.
//
import SwiftUI

struct LifestyleSelectionView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                NavigationLink(destination: StampMapView()) {
                    Text("스탬프 맵")
                        .font(.title)
                        .frame(width: 300,height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                }
                HStack {
                    // NavigationLink로 라이프스타일 버튼을 감싸서 클릭 시 상세 화면으로 이동하게 만듦
                    NavigationLink(destination: TourlistView()) {
                        Text("투어 리스트")
                            .font(.title)
                            .frame(width: 150, height: 150)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    
                    NavigationLink(destination: SelectArrivalStation()) {
                        Text("역 선택")
                            .font(.title)
                            .frame(width: 150, height: 150)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    LifestyleSelectionView()
}
