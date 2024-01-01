

import Foundation
import Firebase


struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
    }
}

enum AuthenticationOption: String{
    case google = "google.com"
   case email = "password"
}

final class AuthenticationMamager{
    
    static let shared = AuthenticationMamager()
    private init(){}
    
    func getAuthenticationMamager()throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
        
    }
    ///google.com
    func getProvider() throws -> [AuthenticationOption]{
           guard let providerData = Auth.auth().currentUser?.providerData
            else{
               throw URLError(.badServerResponse)
               
           }
        var providers: [AuthenticationOption] = []
            for provider in providerData{
                if let option = AuthenticationOption(rawValue: provider.providerID){
                    providers.append(option)
                }else{
                   
                    assertionFailure("Provider option not found: \(provider.providerID)")
                }
            }
        return providers
        }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    
}

extension AuthenticationMamager{
    
    @discardableResult
    
   func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel{
       let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                      accessToken: tokens.accessToken)
       return try await signIn(credential: credential)
  }
    
    func signIn(credential: AuthCredential)async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
  }
}
