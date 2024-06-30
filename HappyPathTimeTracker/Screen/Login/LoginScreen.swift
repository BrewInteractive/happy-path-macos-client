//
//  LoginScreen.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 13.09.2023.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var loginVm = LoginScreenViewModel()
    
    var body: some View {
        RoundedContainer {
            VStack(spacing: 16) {
                HappyPathIcon()
                VStack(spacing: 4) {
                    Text("Signin error occured")
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .opacity(loginVm.isErrorShown ? 1.0 : 0.0)
                    Title()
                }
                VStack(spacing: 12) {
                    EmailAddress()
                    Password()
                    SignInButton()
                }
                RecoverPassword()
            }
            .onChange(of: loginVm.email, perform: { value in
                loginVm.isErrorShown = false
            })
            .onChange(of: loginVm.password, perform: { value in
                loginVm.isErrorShown = false
            })
        }
        .task {
            loginVm.initialize(appState: appState)
        }
    }
    
    @ViewBuilder
    func SignInButton() -> some View {
        LargeButton(title: "Sign in", disabled: loginVm.email.isEmpty || loginVm.password.isEmpty, isLoading: loginVm.isLoading) {
            Task {
                await loginVm.login(email: loginVm.email, password: loginVm.password)
            }
        }
    }
    
    @ViewBuilder
    func EmailAddress() -> some View {
        VStack(alignment: .leading) {
            Text("Email address")
                .font(.figtree(size: 14, weight: .medium))
                .foregroundStyle(Color.Primary.DarkNight)
            RoundedTextField(text: $loginVm.email)
        }
    }
    
    @ViewBuilder
    func Password() -> some View {
        VStack {
            HStack {
                Text("Password")
                    .font(.figtree(size: 14, weight: .medium))
                    .foregroundStyle(Color.Primary.DarkNight)
                Spacer()
                                    Link("Forgot password ?", destination: URL(string: "https://app.usehappypath.com/forgot-password")!)
            }
            RoundedTextField(text: $loginVm.password, type: .password)
        }
    }
    
    @ViewBuilder
    func RecoverPassword() -> some View {
        VStack(spacing: 4) {
            Text("Not sure about your password ?")
                .font(.figtree(size: 14, weight: .medium))
                .foregroundStyle(Color.ShadesofCadetGray.CadetGray600)
            Link("Recover your password", destination: URL(string: "https://app.usehappypath.com/forgot-password")!)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func Title() -> some View{
        Text("Sign in to your account")
            .font(.figtree(size: 24, weight: .medium))
            .foregroundStyle(Color.Primary.DarkNight)
    }
    
    @ViewBuilder
    func HappyPathIcon() -> some View {
        Image("hummingbird")
            .resizable()
            .foregroundStyle(.black)
            .frame(width: 48, height: 48)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

//#Preview {
//    LoginScreen()
//}
