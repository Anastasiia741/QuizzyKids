//  AppTextField.swift
//  Quizzy Kids

import SwiftUI

struct AppTextField: View {
    @Binding var text: String

    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var showsSecureToggle: Bool = false

    var hasError: Bool = false
    var isDisabled: Bool = false

    init(
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        showsSecureToggle: Bool = false,
        hasError: Bool = false,
        isDisabled: Bool = false
    ) {
        _text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.showsSecureToggle = showsSecureToggle
        self.hasError = hasError
        self.isDisabled = isDisabled
    }

    @FocusState private var isFocused: Bool
    @State private var isSecureHidden: Bool = true

    var body: some View {
        ZStack(alignment: .leading) {

            if text.isEmpty {
                Text(placeholder)
                    .font(AppFont.body())
                    .foregroundColor(.textSecondary.opacity(0.6))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }

            HStack(spacing: 8) {
                fieldView
                    .font(AppFont.body())
                    .foregroundColor(isDisabled ? .textSecondary.opacity(0.5) : .textPrimary)
                    .keyboardType(keyboardType)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .focused($isFocused)
                    .disabled(isDisabled)

                if isSecure && showsSecureToggle {
                    Button { isSecureHidden.toggle() } label: {
                        Image(systemName: isSecureHidden ? "eye" : "eye.slash")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.textSecondary.opacity(0.8))
                            .padding(.trailing, 12)
                    }
                    .buttonStyle(.plain)
                    .disabled(isDisabled)
                }
            }
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(10)
        .opacity(isDisabled ? 0.6 : 1.0)
        .onAppear { if isSecure { isSecureHidden = true } }
    }

    @ViewBuilder
    private var fieldView: some View {
        if isSecure && isSecureHidden {
            SecureField("", text: $text)
        } else {
            TextField("", text: $text)
        }
    }

    private var borderColor: Color {
        if hasError { return .red }
        return isFocused ? .textPrimary.opacity(0.4) : .clear
    }
}
