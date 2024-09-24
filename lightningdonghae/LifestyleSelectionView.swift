//
//  LifestyleSelectionView.swift
//  lightningdonghae
//
//  Created by 문재윤 on 9/24/24.
//
import SwiftUI

struct LifestyleSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    // 라이프스타일 선택 액션
                }) {
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

                Button(action: {
                    // 도착역 선택 액션
                }) {
                    VStack {
                        Image(systemName: "train.side.front.car.fill")
                            .font(.largeTitle)
                        Text("도착역 선택")
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding()
    }
}
