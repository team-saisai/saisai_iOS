//
//  ContentView.swift
//  SaiSai
//
//  Created by yeosong on 7/5/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - 앱 main title
                HStack(spacing: 0) {
                    Text("사이사이")
                        .font(.hakgoyansimSamulham)
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {
                        // TODO: - 알림 버튼 기능 구현
                        print("알림 버튼 클릭")
                    }, label: {
                        Image("icBell")
                    })
                }
                .padding(.bottom, 24)
                // MARK: - 웰컴 텍스트
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("안녕하세요 델라님!")
                        Text("오늘도 함께 달려보아요:)")
                    }
                    .font(.pretendard(.medium, size: 26))
                    .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.bottom, 12)
                
                // MARK: - 기상정보(API 연동)
                HStack(spacing: 18) {
                    HStack(spacing: 4) {
                        Image("icPin")
                        Text("서울 마포구")
                    }
                    HStack(spacing: 4) {
                        Image("icCloud")
                        Text("19.6C")
                    }
                    Spacer()
                }
                .font(.pretendard(.regular, size: 13))
                .foregroundStyle(.gray30)
                .padding(.bottom, 32)
                
                // MARK: - 최근 코스(API 연동?)
                recentlyCourseView
                    .padding(.bottom, 40)
                // MARK: - 인기 챌린지(API 연동)
                favoriteChallengeView
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
        }
        .padding(.top, 1)
        .background(.gray90)
        .onAppear {
            
        }
    }
    
    private var recentlyCourseView: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("최근 챌린지")
                        .font(.pretendard(size: 12))
                    Text("여의서로 - 여의대로")
                        .font(.pretendard(.semibold, size: 20))
                        .padding(.bottom, 34)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("2024.06.10")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(.gray70)
                    HStack(spacing: 12) {
                        Text("총거리 5.8km")
                        Text("완주율 100%")
                    }
                }
            }
            .foregroundStyle(.white)
            Spacer()
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    // TODO: - 다시 도전하기 기능구현
                    print("다시 도전하기 클릭")
                }, label: {
                    Text("다시 도전하기")
                        .foregroundStyle(.white)
                        .font(.pretendard(.medium, size: 12))
                })
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color(red: 87 / 255, green: 59 / 255, blue: 245 / 255)))
            }
        }
        .padding(.all, 18)
        .background(RoundedRectangle(cornerRadius: 8).fill(.gray100.opacity(0.04)))
    }
    // MARK: - 인기 챌린지 뷰
    private var favoriteChallengeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("인기 챌린지")
                    .foregroundStyle(.white)
                    .font(.pretendard(.semibold, size: 18))
                Spacer()
            }
            .padding(.bottom, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    favoriteChallengeItemView
                    favoriteChallengeItemView
                    favoriteChallengeItemView
                }
            }
        }
    }
    // MARK: - 인기 챌린지 아이템 뷰
    private var favoriteChallengeItemView: some View {
        // TODO: - 길 이름, 난이도, 도전인원등은 API 에서 데이터 받아서 보여줘야 함.
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 이미지
                Image("icMapEx")
                 
                VStack(alignment: .leading, spacing: 0) {
                    Text("여의대로 - 국회대로")
                        .foregroundStyle(.white)
                        .font(.pretendard(.medium, size: 16))
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 0) {
                        Text("8.6km")
                        Text("난이도 중")
                    }
                    .padding(.bottom, 10)
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(.gray40)
                    
                    Text("207명 도전중")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(Color(red: 128 / 255, green: 105 / 255, blue: 253 / 255))
                        .padding(.bottom, 14)
                }
                .padding(.horizontal, 12)
                
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(0.04)))
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("~6/31")
                        .font(.pretendard(.medium, size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 222 / 255, green: 102 / 255, blue: 102 / 255)))
                        .padding(.leading, 5)
                        .padding(.top, 5)
                   
                    Spacer()
                }
              
                Spacer()
            }
        
        }
     
    }
    
    // MARK: - 배지 컬렉션 뷰
}

#Preview {
    HomeView()
}
