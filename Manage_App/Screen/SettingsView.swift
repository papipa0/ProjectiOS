//
//  SettingsView.swift
//  Manage_App

import SwiftUI

final class SettingsViewModel: ObservableObject{
    
    @Published var authProviders: [AuthenticationOption] = []
    
    func signOut() throws{
        try AuthenticationMamager.shared.signOut()
    }
    func loadAuthProviders() {
      
        if let providers = try? AuthenticationMamager.shared.getProvider(){
            authProviders = providers
        }
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @EnvironmentObject private var model: PlaceModel
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            Text("Setting")
            .font(.title2)
            List{
                Button("Log out"){
                    Task{
                        do{
                            try viewModel.signOut()
                            model.clearData()
                            model.onLogin = false
                            showSignInView = true
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            
        }
      
        .onAppear{
            viewModel.loadAuthProviders()
        }
      
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
       
    }
}

