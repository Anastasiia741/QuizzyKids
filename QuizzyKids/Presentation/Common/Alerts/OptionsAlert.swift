//  OptionsAlert.swift
//  Quizzy Kids

import SwiftUI

struct OptionsAlert: View {
    @Binding var sound: Double
    @Binding var music: Double
    let onClose: () -> Void
    
    var body: some View {
        AlertCard(maxWidth: 360) {
            VStack(spacing: 0) {
                Text("Options")
                    .font(AppFont.headline())
                    .foregroundColor(.secondary100)
                    .padding(.vertical, 10)
                    .padding(.top, 6)
                    .frame(maxWidth: .infinity)
                    .background(Color.colorE0D0E9)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 69)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 18) {
                    sliderRow(title: "Sound", value: $sound)
                    sliderRow(title: "Music", value: $music)
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
                
                Button(action: onClose) {
                    Text("Close")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    AppButtonStyle(
                        type: .primary,
                        customPressedBackgroundColor: Color.primary100.opacity(0.85)
                    )
                )
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 22)
            }
        }
    }
    
    private func sliderRow(title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AppFont.headline())
                .foregroundColor(.black)
            
            Slider(value: value, in: 0...1)
        }
    }
}
