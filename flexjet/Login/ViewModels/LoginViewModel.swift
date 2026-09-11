//
//  LoginViewModel.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Combine
import FactoryKit
import Foundation

final class LoginViewModel: ObservableObject {
    @Injected(\.authRepository) private var authRepo

    @Published var username = "" {
        didSet {
            if !username.isEmpty {
                errorMessage = nil
            }
        }
    }

    @Published var password = "" {
        didSet {
            if !password.isEmpty {
                errorMessage = nil
            }
        }
    }
    
    @Published var errorMessage: String?
    @Published var isLoading = false

    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password are required."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            errorMessage = nil
            try await authRepo.login(username: username, password: password)
        } catch {
            errorMessage = "We're sorry, that didn't work. Please try again."
        }
    }
}
