//
//  MainView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack {
            containedView()
        }
    }
    
    func containedView() -> AnyView {
       switch model.viewStatus {
       case .shareView: return AnyView(ShareView())
       case .sendInviteView: return AnyView(SendInviteView())
       case .loginView: return AnyView(LoginView())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
