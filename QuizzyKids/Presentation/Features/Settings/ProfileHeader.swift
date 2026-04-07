//  ProfileHeader.swift
//  Quizzy Kids

import SwiftUI

struct ProfileHeader: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @AppStorage(AvatarStorage.key) private var profileAvatarAsset: String = Avatar.avatar01.rawValue
    private var isPadLike: Bool { hSizeClass == .regular }
    private var avatarImageName: String {
        profileAvatarAsset.isEmpty ? Avatar.avatar01.rawValue : profileAvatarAsset
    }
    
    let name: String
    let bonuses: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Image(avatarImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            
            Text(name)
                .font(AppFont.callout() )
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            
            HStack(spacing: 8) {
                Text("\(bonuses)")
                    .font(AppFont.body())
                    .foregroundColor(.black)
                
                Image(Icons.icon13.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal,  6)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.accent100)
            )
        }
        .padding(.horizontal)
        .padding(.top,  12)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity)
        .background {
            Image(Background.bg10.rawValue)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea(edges: .top)
        }
    }
}
