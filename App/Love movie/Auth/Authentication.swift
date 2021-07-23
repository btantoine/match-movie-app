//
//  Authentication.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/4/21.
//

import SwiftUI

struct Authentication: View {
    @State var vm: ViewModel
    var body: some View {
        VStack {
            Spacer()
            Text("Hello,\nWelcome to Love Movie")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 10)
            Spacer()
            Button(action: { self.vm.getRequest() }) {
                AppleIdButton()
                    .background(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(7)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 76)
            }
            Spacer()
        }
        .shadow(color: Color.secondary.opacity(0.5), radius: 10, y: 8)
    }
}


struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication(vm: ViewModel())
    }
}
