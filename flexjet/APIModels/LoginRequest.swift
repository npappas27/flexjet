//
//  LoginRequest.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}
