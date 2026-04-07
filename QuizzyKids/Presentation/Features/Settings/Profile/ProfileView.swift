//  ProfileView.swift
//  Quizzy Kids

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel
    @StateObject private var viewModel = ProfileViewModel()

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private enum Field { case name, age }
    @FocusState private var focusedField: Field?
    @State private var showBirthDatePickerSheet = false

    private var isPadLike: Bool { horizontalSizeClass == .regular }
    private var contentMaxWidth: CGFloat { isPadLike ? 640 : .infinity }
    private var horizontalPadding: CGFloat { isPadLike ? 32 : 20 }
    private var avatarDim: CGFloat { isPadLike ? 96 : 68 }
    private var editIconSize: CGFloat { isPadLike ? 22 : 18 }

    var body: some View {
        ZStack {
            Color.accent100
                .ignoresSafeArea()
                .onTapGesture { focusedField = nil }
            VStack(spacing: 0) {
                VStack(spacing: isPadLike ? 12 : 8) {
                    Button {
                        coordinator.present(.avatarPicker)
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            Image(viewModel.selectedAvatar)
                                .resizable()
                                .scaledToFill()
                                .frame(width: avatarDim, height: avatarDim)
                                .clipShape(Circle())

                            Image(Icons.icon04.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: editIconSize, height: editIconSize)
                                .padding(isPadLike ? 8 : 6)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x: 4, y: 4)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Change avatar")

                    Text(viewModel.headerDisplayName)
                        .font(isPadLike ? AppFont.title3() : AppFont.body())
                        .foregroundColor(.grayscale400)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)

                    HStack(spacing: 8) {
                        Text(viewModel.bonusesDisplay)
                            .font(isPadLike ? AppFont.body() : AppFont.body2())
                            .foregroundColor(.grayscale400)
                        Image(Icons.icon13.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: isPadLike ? 22 : 18, height: isPadLike ? 22 : 18)
                    }
                    .padding(.horizontal, isPadLike ? 16 : 12)
                    .padding(.vertical, isPadLike ? 10 : 8)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.accent300)
                    )
                }

                VStack(spacing: isPadLike ? 16 : 12) {
                    AppTextField(text: $viewModel.name, placeholder: "Name")
                        .focused($focusedField, equals: .name)
                    AppTextField(text: $viewModel.email, placeholder: "Email address", keyboardType: .emailAddress)
                        .disabled(true)
                        .allowsHitTesting(false)

                    HStack(alignment: .center, spacing: 12) {
                        AppTextField(text: $viewModel.ageText, placeholder: "Age", keyboardType: .numberPad)
                            .focused($focusedField, equals: .age)
                            .frame(width: isPadLike ? 120 : 96)
                            .onChange(of: viewModel.ageText) { _, _ in
                                viewModel.reactToAgeTextChange()
                            }

                        Button {
                            focusedField = nil
                            showBirthDatePickerSheet = true
                        } label: {
                            HStack {
                                Text(viewModel.birthDateDisplayText)
                                    .font(AppFont.body())
                                    .foregroundColor(.textPrimary)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Date of birth")
                    }

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(AppFont.body2())
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 6)
                    }
                }
                .padding(.top, isPadLike ? 40 : 36)
                Spacer(minLength: 0)
                Button {
                    focusedField = nil
                    Task {
                        if await viewModel.saveDraft() {
                            coordinator.pop()
                        }
                    }
                } label: {
                    Text("Save")
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.9 : 1.0)
                .buttonStyle(AppButtonStyle(type: .primary))
                .padding(.bottom, isPadLike ? 40 : 32)
            }
            .padding(.top, isPadLike ? 24 : 20)
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: contentMaxWidth)
            .frame(maxWidth: .infinity)
            if viewModel.isLoading {
                Color.black.opacity(0.12)
                    .ignoresSafeArea()
                    .zIndex(999)
                ProgressView()
                    .tint(.black)
                    .scaleEffect(1.4)
                    .zIndex(1000)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "Edit profile",
                showsTitle: true,
            )
        }
        .navigationBarBackButtonHidden(true)
        .task { await viewModel.loadForm(currentUser: authVM.user) }
        .onChange(of: viewModel.birthDate) { _, _ in
            viewModel.syncAgeFromBirthDate()
        }
        .sheet(isPresented: $showBirthDatePickerSheet) {
            BirthDatePickerSheet(
                birthDate: $viewModel.birthDate,
                onDone: { showBirthDatePickerSheet = false }
            )
        }
        .sheet(item: $coordinator.sheet) { sheet in
            switch sheet {
            case .avatarPicker:
                AvatarPickerSheet(
                    selectedAvatar: $viewModel.selectedAvatar,
                    onSelect: { avatar in
                        viewModel.selectAvatar(assetName: avatar)
                        coordinator.dismissSheet()
                    }
                )
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
            case .scoreView:
                EmptyView()
            }
        }
    }
}
