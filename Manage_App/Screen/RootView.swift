//
//  RootView.swift


import SwiftUI

struct RootView: View {
    //ถ้ามีการเปลี่ยนแปลงค่าจะมีการวนมาเช็คเสมอ state
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            if !showSignInView{
                NavigationStack{
                    AppTabBarView(showSignInView: $showSignInView)
                  
                }
            } else {
                AuthenticationView(showSignInViwe: $showSignInView) {
                    
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationMamager.shared.getAuthenticationMamager()
            self.showSignInView = authUser == nil
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
