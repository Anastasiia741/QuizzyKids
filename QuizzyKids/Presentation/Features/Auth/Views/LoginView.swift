//  LoginView.swift
//  Quizzy Kids

import SwiftUI
import UIKit

struct LoginView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel
    
    enum Mode { case login, signUp }
    private enum Field { case name, email, password }
    
    private let startMode: Mode
    @State private var mode: Mode
    @FocusState private var focusedField: Field?
    
    init(startMode: Mode = .login) {
        self.startMode = startMode
        _mode = State(initialValue: startMode)
    }
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }
            VStack(spacing: 0) {
                Text(mode == .login ? "Log in" : "Sign Up")
                    .font(AppFont.title2())
                    .foregroundColor(.black)
                    .padding(.top, 60)
                
                VStack(spacing: 12) {
                    if mode == .signUp {
                        AppTextField(
                            text: $authVM.displayName,
                            placeholder: "Name",
                            keyboardType: .default,
                            hasError: authVM.nameHasError
                        )
                        .focused($focusedField, equals: .name)
                    }
                    
                    AppTextField(
                        text: $authVM.email,
                        placeholder: "Email address",
                        keyboardType: .emailAddress,
                        hasError: authVM.emailHasError
                    )
                    .focused($focusedField, equals: .email)
                    
                    AppTextField(
                        text: $authVM.password,
                        placeholder: "Password",
                        isSecure: true,
                        showsSecureToggle: false,
                        hasError: authVM.passwordHasError
                    )
                    .focused($focusedField, equals: .password)
                    HStack {
                        Spacer()
                        if mode == .login {
                            Button {
                                coordinator.push(.forgotPassword)
                            } label: {
                                Text(verbatim: "Forgot password?")
                                    .font(AppFont.body())
                                    .foregroundStyle(.grayscale400)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    if !authVM.errorMessage.isEmpty {
                        Text(authVM.errorMessage)
                            .font(AppFont.body())
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 28)
                .padding(.bottom, 32)
                
                Button {
                    focusedField = nil
                    authVM.flow = (mode == .login) ? .login : .signUp
                    authVM.errorMessage = ""
                    
                    Task {
                        if mode == .login {
                            _ = await authVM.singInWithEmail()
                        } else {
                            _ = await authVM.singUpWithEmailPassword()
                        }
                    }
                } label: {
                    Text(mode == .login ? "Log in" : "Sign Up")
                }
                .disabled(!authVM.isValid || authVM.authenticationState == .authenticating)
                .opacity((!authVM.isValid || authVM.authenticationState == .authenticating) ? 0.9 : 1.0)
                .buttonStyle(
                    AppButtonStyle(
                        type: .primary,
                        customBackgroundColor: .primary100,
                        customPressedBackgroundColor: Color.primary100.opacity(0.85),
                        bottomBorderColor: .black
                    )
                )
                .padding(.top, 18)
                
                HStack(spacing: 4) {
                    Text(mode == .login ? "Don’t have an account?" : "Already have an account?")
                        .font(AppFont.body())
                        .foregroundStyle(.grayscale400)
                    Button {
                        withAnimation(.easeInOut) {
                            mode = (mode == .login) ? .signUp : .login
                            authVM.flow = (mode == .login) ? .login : .signUp
                            authVM.password = ""
                            authVM.errorMessage = ""
                            focusedField = nil
                        }
                    } label: {
                        Text(mode == .login ? "Sign Up" : "Log in")
                            .font(AppFont.body2())
                            .foregroundColor(.secondary200)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 16)
                
                HStack(spacing: 12) {
                    Rectangle().fill(Color.grayscale400.opacity(0.35)).frame(height: 1)
                    Text("Or sign in with")
                        .font(AppFont.body())
                        .foregroundStyle(.grayscale300)
                    Rectangle().fill(Color.grayscale400.opacity(0.35)).frame(height: 1)
                }
                .padding(.top, 18)
                
                HStack(spacing: 12) {
                    socialButton(title: "Google", icon: Icons.icon07.rawValue)
                    socialButton(title: "Apple", icon: Icons.icon01.rawValue)
                }
                .padding(.top, 14)
                
                Image(Background.bg02.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 20)
            if authVM.authenticationState == .authenticating {
                Color.black.opacity(0.12).ignoresSafeArea()
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            mode = startMode
            authVM.flow = (mode == .login) ? .login : .signUp
        }
        .onChange(of: mode) {_,  newMode in
            authVM.flow = (newMode == .login) ? .login : .signUp
            authVM.errorMessage = ""
        }
        .onChange(of: authVM.displayName) { _, _ in authVM.nameHasError = false }
        .onChange(of: authVM.email) { _, _ in authVM.emailHasError = false }
        .onChange(of: authVM.password) { _, _ in authVM.passwordHasError = false }
    }
    
    private func socialButton(title: String, icon: String) -> some View {
        Button {
            focusedField = nil
            authVM.errorMessage = ""
            
            Task {
                switch title {
                case "Google":
                    _ = await authVM.signInWithGoogle()
                case "Apple":
                    await authVM.startAppleSignIn()
                default:
                    break
                }
            }
        } label: {
            HStack(spacing: 10) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text(title)
            }
        }
        .buttonStyle(AppButtonStyle(type: .social))
    }
}

