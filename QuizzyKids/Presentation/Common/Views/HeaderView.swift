//  AuthHeaderView.swift
//  Quizzy Kids

import SwiftUI
import FirebaseAuth

struct HeaderView: View {
    @EnvironmentObject private var authVM: AuthentificationViewModel
    @StateObject private var profileVM = SettingsViewModel.shared
    let backgroundImage: String?
    let showsBack: Bool
    let onBack: (() -> Void)?
    let title: String?
    let showsTitle: Bool
    let avatarImage: String?
    let showsNotification: Bool
    let onTapNotification: (() -> Void)?
    let showsStarsBadge: Bool
    
    let onTapStars: (() -> Void)?
    let rightSystemIcon: String?
    let rightAssetIcon: String?
    let onRightTap: (() -> Void)?
    
    
    private var resolvedName: String {
        profileVM.profile?.name ?? authVM.user?.displayName ?? "—"
    }
    
    private var resolvedBonuses: Int {
        profileVM.profile?.bonuses ?? 100
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<5:   return "Good night"
        case 5..<12:  return "Good morning"
        case 12..<18: return "Hello Little"
        default:      return "Good evening"
        }
    }

    init(
        backgroundImage: String? = Background.bg07.rawValue,
        showsBack: Bool = false,
        onBack: (() -> Void)? = nil,
        title: String? = nil,
        showsTitle: Bool = false,
        avatarImage: String? = Avatar.avatar01.rawValue,
        titleTop: String? = nil,
        showsNotification: Bool = false,
        onTapNotification: (() -> Void)? = nil,
        showsStarsBadge: Bool = false,
        onTapStars: (() -> Void)? = nil,
        rightSystemIcon: String? = nil,
        rightAssetIcon: String? = nil,
        onRightTap: (() -> Void)? = nil
    ) {
        self.backgroundImage = backgroundImage
        self.showsBack = showsBack
        self.onBack = onBack
        self.title = title
        self.showsTitle = showsTitle
        self.avatarImage = avatarImage
        self.showsNotification = showsNotification
        self.onTapNotification = onTapNotification
        self.showsStarsBadge = showsStarsBadge
        self.onTapStars = onTapStars
        self.rightSystemIcon = rightSystemIcon
        self.rightAssetIcon = rightAssetIcon
        self.onRightTap = onRightTap
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if let bg = backgroundImage {
                Image(bg)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea(edges: .top)
            }
            HStack(spacing: 0) {
                leftView
                Spacer()
                if showsTitle, let title {
                    Text(title)
                        .font(AppFont.headline())
                        .foregroundColor(.black)
                }
                Spacer()
                rightView
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 80)
        .task {
            await profileVM.loadProfileIfNeeded(user: authVM.user)
        }
    }
    
    @ViewBuilder
    private var leftView: some View {
        if showsBack, let onBack {
            Button(action: onBack) {
                headerCircle {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)
        } else if let avatar = avatarImage {
            HStack(spacing: 12) {
                Image(avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0) {
                    Text(greeting)
                        .font(AppFont.body2())
                        .foregroundStyle(.grayscale400)
                    Text(resolvedName)
                        .font(AppFont.body2())
                        .foregroundStyle(.grayscale400)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.9)
                }
            }
        } else {
            Color.clear.frame(width: 40, height: 40)
        }
    }
    
    @ViewBuilder
    private var rightView: some View {
        HStack(spacing: 8) {
            if showsNotification, let onTapNotification {
                Button(action: onTapNotification) {
                    Image(Icons.icon09.rawValue)
                        .resizable()
                        .padding(8)
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            
            if showsStarsBadge {
                StarsBadgeView(starsCount: resolvedBonuses, onTap: onTapStars)
                
            } else if let onRightTap, (rightSystemIcon != nil || rightAssetIcon != nil) {
                Button(action: onRightTap) {
                    headerCircle {
                        rightIconView
                    }
                }
                .buttonStyle(.plain)
                
            } else {
                Color.clear.frame(width: 36, height: 36)
            }
        }
    }
    
    @ViewBuilder
    private var rightIconView: some View {
        if let system = rightSystemIcon {
            Image(system)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
        } else if let asset = rightAssetIcon {
            Image(asset)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundColor(.black)
        }
    }
    
    private func headerCircle<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content()
            .frame(width: 40, height: 40)
            .background(Color.white)
            .clipShape(Circle())
    }
}
