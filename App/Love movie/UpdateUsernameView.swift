//
//  UpdateUsernameView.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/19/21.
//

import SwiftUI

struct UpdateUsernameView: View {
    @State var username: String = ""
    @State var submitFailed = false

    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Update your username")) {
                    HStack {
                        TextField("Group title", text: $username)
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            Auth_Api().post_username(
                                userId: user_mongo_id,
                                username: username) { (result, error) in
                                if (result != nil) {
                                    DispatchQueue.main.async {
                                        self.mode.wrappedValue.dismiss()
                                    }
                                    }
                                if (error != nil) {
                                    self.submitFailed.toggle()
                                }
                            }
                        }) { Text("Submit") }
                        .alert(isPresented: $submitFailed) {
                            Alert(
                                title: Text("This username is already used"))
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

struct UpdateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUsernameView()
    }
}
