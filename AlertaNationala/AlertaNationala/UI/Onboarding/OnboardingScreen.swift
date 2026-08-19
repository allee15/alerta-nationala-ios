//
//  OnboardingScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.pageIndex) {
                ForEach(0..<3) { index in
                    OnboardingPageView(page: viewModel.onboardingPages[index])
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
            
            VStack(spacing: 12) {
                NavSliderView(currentStep: viewModel.pageIndex) {
                    viewModel.nextPage()
                }
                
                PrimaryButton(text: viewModel.pageIndex == viewModel.onboardingPages.count - 1 ? "Login" : "Continua") {
                    viewModel.nextPage()
                }
            }.padding(.horizontal, 20)
                .padding(.bottom, 28)
        }.background(Color.bgPrimary)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.push(LoginScreen().asDestination(), animated: true)
                }
            }
    }
}

fileprivate struct OnboardingPageView: View {
    let page: OnboardingData
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer(minLength: 40)
            
            HStack {
                Spacer()
                
                Image(page.image)
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Spacer()
            }
            .padding(.bottom, 12)
            
            Text(page.title)
                .font(.poppinsBold(size: 32))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(page.description)
                .font(.poppinsRegular(size: 16))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }.padding(.horizontal, 20)
    }
}

fileprivate struct NavSliderView: View {
    let currentStep: Int
    let buttonAction: () -> ()
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { step in
                Button {
                    buttonAction()
                } label: {
                    Circle()
                        .fill(step == currentStep ? Color.white : Color(hex: "#FFFCFC").opacity(0.6))
                        .frame(height: 12)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        
    }
}
