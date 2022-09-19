//
//  Validation.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/3/22.
//

import Foundation
import UIKit

protocol Validatable {
    func validate() throws
}

extension LoginInputValidator {
    // TODO: - Add Error description once available from design
    enum LoginError: Error {
        case emailEmpty
        case emailInvalid
        case passwordEmpty
        case passwordInvalid
    }
}

final class LoginInputValidator: Validatable {
    private let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    private let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]{8,16}")
    
    var email: String?
    var password: String?
    
    var isValidEmail: Bool {
        return emailPredicate.evaluate(with: email)
    }
    
    var isValidPassword: Bool {
        return passwordPredicate.evaluate(with: password)
    }
    
    func validate() throws {
        if email == nil {
            throw LoginError.emailEmpty
        } else if isValidEmail == false {
            throw LoginError.emailInvalid
        }
        
        if password == nil {
            throw LoginError.passwordEmpty
        } else if isValidPassword == false {
            throw LoginError.passwordInvalid
        }
    }
}
