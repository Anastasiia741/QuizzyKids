//  SettingsRow.swift
//  Quizzy Kids

import SwiftUI

struct SettingsRow: View {
    enum Trailing {
        case chevron(action: () -> Void)
        case toggle(isOn: Binding<Bool>)
    }
    let title: String
    let trailing: Trailing
    
    @Environment(\.horizontalSizeClass) private var hSizeClass
    private var isPadLike: Bool { hSizeClass == .regular }
    private var rowH: CGFloat { isPadLike ? 68 : 60 }
    private var hPad: CGFloat { isPadLike ? 22 : 18 }
    private var trailingPad: CGFloat { isPadLike ? 22 : 18 }
    private var chevronSize: CGFloat { isPadLike ? 18 : 16 }
    private var titleFont: Font { isPadLike ? AppFont.subheadline() : AppFont.body2() }
    private var toggleW: CGFloat { isPadLike ? 52 : 44 }
    private var toggleH: CGFloat { isPadLike ? 28 : 24 }
    private var knob: CGFloat { isPadLike ? 20 : 18 }
    private var knobPad: CGFloat { isPadLike ? 4 : 3 }
    
    var body: some View {
        switch trailing {
        case .chevron(let action):
            Button(action: action) {
                rowContent
            }
            .buttonStyle(.plain)
            
        case .toggle:
            rowContent
        }
    }
    
    private var rowContent: some View {
        HStack {
            Text(title)
                .font(titleFont)
                .foregroundColor(.grayscale400)
            
            Spacer()
            
            trailingView
                .padding(.trailing, trailingPad)
        }
        .padding(.horizontal, hPad)
        .frame(height: rowH)
        .background(Color.accent400)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .chevron:
            Image(Icons.icon17.rawValue)
                .font(.system(size: chevronSize))
            
        case .toggle(let isOn):
            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    isOn.wrappedValue.toggle()
                }
            } label: {
                ZStack(alignment: isOn.wrappedValue ? .trailing : .leading) {
                    Capsule()
                        .fill(isOn.wrappedValue ? Color.primary100 : Color.gray.opacity(0.35))
                        .frame(width: toggleW, height: toggleH)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: knob, height: knob)
                        .padding(knobPad)
                        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
                }
            }
            .buttonStyle(.plain)
        }
    }
}
