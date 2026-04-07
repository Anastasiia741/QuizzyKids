//  ForgotPasswordView.swift
//  Quizzy Kids

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel
    private enum Field { case email }
    @FocusState private var focusedField: Field?

    @State private var email: String = ""
    @State private var isSent: Bool = false
    @State private var autoCloseTask: Task<Void, Never>? = nil

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }
            VStack(spacing: 0) {
                HeaderView(
                    backgroundImage: nil,
                    showsBack: true,
                    onBack: { coordinator.pop() },
                    title: ""
                )
                
                Spacer().frame(height: 34)
                
                Text("Forgot password?")
                    .font(AppFont.title2())
                    .foregroundColor(.grayscale400)
                
                Text("Enter your email and we’ll send a reset link.")
                    .font(AppFont.body())
                    .foregroundStyle(.grayscale400)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                AppTextField(
                    text: $email,
                    placeholder: "Email address",
                    keyboardType: .emailAddress,
                    hasError: authVM.emailHasError
                )
                .focused($focusedField, equals: .email)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .onChange(of: email) { _, _ in
                    authVM.emailHasError = false
                    authVM.errorMessage = ""
                    isSent = false
                    
                    autoCloseTask?.cancel()
                    autoCloseTask = nil
                }
                
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .font(AppFont.body())
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                }
                
                if isSent {
                    Text("Reset link sent check your email")
                        .font(AppFont.body())
                        .foregroundStyle(.grayscale400)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                }
                
                Button {
                    focusedField = nil
                    Task {
                        let ok = await authVM.sendPasswordReset(email: email)
                        if ok {
                            await MainActor.run { isSent = true }
                            
                            autoCloseTask?.cancel()
                            autoCloseTask = Task {
                                try? await Task.sleep(nanoseconds: 20_000_000_000)
                                guard !Task.isCancelled else { return }
                                await MainActor.run {
                                    coordinator.popToRoot()
                                    coordinator.push(.login)
                                }
                            }
                        }
                    }
                } label: {
                    Text("Send reset link")
                }
                .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.8 : 1.0)
                .buttonStyle(
                    AppButtonStyle(
                        type: .primary,
                        customTextColor: .black,
                        customBackgroundColor: .primary100,
                        customPressedBackgroundColor: Color.primary100.opacity(0.85),
                        bottomBorderColor: .black
                    )
                )
                .padding(.horizontal, 20)
                .padding(.top, 18)
                Spacer(minLength: 0)
                Image(Background.bg02.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
            }
            
            if authVM.authenticationState == .authenticating {
                Color.black.opacity(0.12).ignoresSafeArea()
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            autoCloseTask?.cancel()
            autoCloseTask = nil
        }
    }
}
