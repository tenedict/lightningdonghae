//
//  LifestyleSelectionView.swift
//  lightningdonghae
//
//  Created by 문재윤 on 9/24/24.
//
import SwiftUI

struct LifestyleSelectionView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                HStack {
                    // NavigationLink로 라이프스타일 버튼을 감싸서 클릭 시 상세 화면으로 이동하게 만듦
                    NavigationLink(destination: LifestyleDetailView()) {
                        VStack {
                            Image(systemName: "leaf.fill")
                                .font(.largeTitle)
                            Text("라이프스타일 선택")
                        }
                        .frame(width: 150, height: 150)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: TrainScheduleView(), label: {
                            VStack {
                                Image(systemName: "train.side.front.car.fill")
                                    .font(.largeTitle)
                                Text("도착역 선택")
                            }
                            .frame(width: 150, height: 150)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                  
                }
                .padding()
                
                Spacer()
            }
        }
    }
}
