//  BirthDatePickerSheet.swift
//  Quizzy Kids

import SwiftUI

struct BirthDatePickerSheet: View {
    @Binding var birthDate: Date
    let onDone: () -> Void

    var body: some View {
        NavigationStack {
            DatePicker(
                "",
                selection: $birthDate,
                in: ProfileBirthDateSync.selectableRange,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(.primary100)
            .labelsHidden()
            .environment(\.locale, Locale.current)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .navigationTitle("Date of birth")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: onDone)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

