//  DeleteAccountView.swift
//  Quizzy Kids

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 0) {
                HeaderView(onBack: { coordinator.pop() }, title: "Delete account", showsTitle: true)
                
                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Text("Delete account")
                        .font(AppFont.caption2())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.primary100)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Delete account?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                coordinator.pop()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}



