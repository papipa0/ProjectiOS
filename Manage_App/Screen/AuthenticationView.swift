//
//  AuthenticationViw.swift
//  Manage_App
//
//  Created by Pare on 1/4/2566 BE.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    var email:String? = nil
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.email = tokens.email
        try await AuthenticationMamager.shared.signInWithGoogle(tokens: tokens)
       
    }
}

struct AuthenticationView: View {
    
    let defaults = UserDefaults.standard
    @EnvironmentObject private var model: PlaceModel
    
    private func fetchUser(email: String) async {
        do {
            try await model.login(login: Login(_id: "",email: email))
            
            defaults.set(model.login._id, forKey: "Owner")
        } catch {
            print(error)
        }
        
    }

    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInViwe: Bool
    
    var onLogin: () -> Void
    var body: some View {
        
        ZStack{
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
                
                VStack{
                    
                    Spacer().frame(height: 200)
                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel( scheme: .light, style: .wide , state: .normal)){
                        Task{
                            do{
                                try await viewModel.signInGoogle()
                                await fetchUser(email:viewModel.email ?? "")
                                defaults.set(viewModel.email, forKey: "userEmail")
                                showSignInViwe = false
                                onLogin()
                            }catch{
                                print(error)
                            }
                        }
                    
                }
                .cornerRadius(20)
                .frame(width: 350, height: 70 )
                
               
            }
            
        }

    }
}

struct AuthenticationViw_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            
            AuthenticationView(showSignInViwe: .constant(false)) {
                
            }
        }
       
    }
}
