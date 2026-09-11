//
//  ProfileViewModel.swift
//  flexjet
//
//  Created by Nick Pappas on 9/9/26.
//

import Combine
import FactoryKit
import Foundation

final class ProfileViewModel: ObservableObject {
    @Injected(\.authRepository) private var authRepo
    
    func logout() {
        do {
            try authRepo.logout()
        } catch {
            print("error")
        }
    }
}
