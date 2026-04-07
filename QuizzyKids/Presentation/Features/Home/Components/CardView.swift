//  CardView.swift
//  Quizzy Kids

import SwiftUI

struct CardView: View {
   let image: String
   var body: some View {
       VStack(spacing: 10) {
           Image(image)
               .resizable()
               .scaledToFit()
       }
       .frame(height: 220)
       .frame(maxWidth: .infinity)
       .padding(.top, 12)
   }
}
