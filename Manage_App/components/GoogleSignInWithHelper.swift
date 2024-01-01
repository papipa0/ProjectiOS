//
//  File.swift
//  Manage_App


import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel{
    
    let idToken: String
    let accessToken: String
    let email: String?
}

final class SignInGoogleHelper{
    
    @MainActor
    
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVc = Utilities.shared.topViweController()else{
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVc)
        let email = gidSignInResult.user.profile?.email
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString
        else{
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, email: email)
        
        return tokens
    }
}
