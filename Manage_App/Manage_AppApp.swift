//
//  Manage_AppApp.swift
//  Manage_App
//
//  Created by Pare on 1/3/2566 BE.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct Manage_AppApp: App {
    
    @StateObject private var model: PlaceModel
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("signInwithGoogle") var isSignIn = false
    
    init() {
        let webservice = Webservice()
        _model = StateObject(wrappedValue: PlaceModel(webservice: webservice))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                
                RootView()
            }.environmentObject(model)
            
        }
    }
    //app delegate:method,configure
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
        }
        //method call handleurl การตรวจสอบสิทธิ
        @available(iOS 9.0, *)
        func application(_ app: UIApplication,
                         open url: URL,
                         options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
    }
}


