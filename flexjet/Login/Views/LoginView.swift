//
//  LoginView.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            
            Image("flexjet-logo")
                .resizable()
                .scaledToFit()
            
            TextField("Username", text: $viewModel.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            FlexButton(
                title: "Log in",
                isLoading: viewModel.isLoading
            ) {
                Task {
                    await viewModel.login()
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
        .padding()
    }
}

#Preview {
    LoginView()
}
