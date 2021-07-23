//
//  CategoryItem.swift
//  Love movie
//
//  Created by Antoine Boudet on 1/15/21.
//

import SwiftUI

struct CategoryItem: View {
    #if os(iOS)
    var cornerRadius: CGFloat = 22
    #else
    var cornerRadius: CGFloat = 10
    #endif
    
    var body: some View {
        VStack(spacing: 4.0) {
            Spacer()
            HStack {
                Image("Illustration 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                Spacer()
            }
            .padding(.bottom)
            Text("Romantic friday night")
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            Text("Which romantic movie for friday night ?")
                .font(.footnote)
                .foregroundColor(Color.white)
        }
        .padding(.all)
        .background(Color(#colorLiteral(red: 0.9721538424, green: 0.2151708901, blue: 0.5066347718, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: Color(#colorLiteral(red: 0.9721538424, green: 0.2151708901, blue: 0.5066347718, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 10)
    }
}


struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem()
    }
}
