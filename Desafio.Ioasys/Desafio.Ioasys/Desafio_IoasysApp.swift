//
//  Desafio_IoasysApp.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 29/09/20.
//

import SwiftUI
import KeychainSwift

@main
struct Desafio_IoasysApp: App {
    var body: some Scene {
        WindowGroup {
            Login()
                .onAppear(perform: UIApplication.shared.switchHostingController)
        }
    }
}

class HostingController<ContentView>: UIHostingController<ContentView> where ContentView : View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIApplication {
    func switchHostingController() {
        windows.first?.rootViewController = HostingController(rootView: Login())
        
        let keychain = KeychainSwift()
        keychain.clear()
    }
}
