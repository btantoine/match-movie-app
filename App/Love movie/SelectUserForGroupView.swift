//
//  SelectUserForGroupView.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/5/21.
//

import Foundation
import SwiftUI

struct SelectUserForGroupView : View {
    @State var friends = [User]()
    @State var new_user = ""
    @State var isPeopleChosen = false
    @Binding var selectedRows : [String]
    @State var alert = false
    @State var alertNewFriend = false
    @State var alertNotMyself = false
    @State var isLoading = false

    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            if isLoading == false {
                Form {
                    Section(header: Text("Username")) {
                        HStack {
                            TextField("Username", text: $new_user)
                            Button(action: {
                                if (new_user != "") {
                                    Friends_Api().post_friend(
                                        user: user_mongo_id,
                                        new_friend: new_user
                                    ) { (result, error) in
                                        if (error != nil) {
                                            self.alert = true
                                            self.alertNewFriend = true
                                            self.new_user = ""
                                        }
                                        if (result != nil) {
                                            let msg_error = result?["error"] ?? "undefined"
                                            if (msg_error as! String != "undefined") {
                                                self.alert = true
                                                self.alertNotMyself = true
                                                self.new_user = ""
                                            }
                                            let _id = result?["_id"] ?? "undefined"
                                            let firstname = result?["firstname"] ?? "undefined"
                                            let lastname = result?["lastname"] ?? "undefined"
                                            let username = result?["username"] ?? "undefined"
                                            let email = result?["email"] ?? "undefined"
                                            self.new_user = ""
                                            friends.append(User(username: username as! String, _id: _id as! String, firstName: firstname as! String, email: email as! String, userId: "", lastName: lastname as! String,  __v: 0))
                                        }
                                    }
                                }
                            }) {
                                Text("New")
                                    .foregroundColor(Color.blue)
                            }
                            .alert(isPresented: $alert) {
                                if (alertNewFriend == true) {
                                    return Alert(
                                    title: Text("This username doesn't exist"),
                                    message: Text("Please enter a valid username or select one in your list"),
                                    dismissButton: Alert.Button.default(
                                        Text("OK"), action: { self.alert = false; self.alertNewFriend = false }
                                    ))
                                }
                                else {
                                    return Alert(
                                    title: Text("You can't add yourself in this list"),
                                    message: Text("Please enter a valid username or select one in your list"),
                                    dismissButton: Alert.Button.default(
                                        Text("OK"), action: { self.alert = false; self.alertNotMyself = false }
                                    ))
                                }
                            }
                        }
                    }
                    List(friends) { friend in
                        MultiSelectRow(friend: friend, selectedItems: self.$selectedRows)
                    }
                    if friends.count <= 0 {
                        VStack {
                            HStack {
                                Text("No friends found yet.")
                                Spacer()
                            }
                            HStack {
                                Text("Find your username here 👇")
                                    .padding(.top, 5)
                                Spacer()
                            }
                            HStack {
                                Text("On the home page, press:")
                                Image("menu")
                                    .renderingMode(.template)
                                Spacer()
                            }
                            HStack {
                                Text("You can see and update it")
                                Spacer()
                            }
                        }
                    }
                }
                Spacer()
            }
            Spacer()
            if (selectedRows.count >= 1) {
                HStack {
                    Spacer()
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(5.0)
                            .padding(.trailing, 30)
                            .padding(.bottom, 10)
                    }
                }
            }
            if isLoading == true {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            }
        }
        .onAppear {
            Friends_Api().get_friends(user_id: user_mongo_id) { (friends) in
                self.friends = friends.friends
                isLoading = false
            }
        }
        .alert(isPresented: $isPeopleChosen) {
            Alert(
                title: Text("You didn't choose a friend(s)"),
                message: Text("Please select someone in your list or add a new one by using the text field"))
        }
        .navigationBarTitle("\(selectedRows.count) friend\(selectedRows.count > 1 ? "s" : "") selected", displayMode: .inline)
    }
}

//struct SelectUserForGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectUserForGroupView()
//    }
//}


struct MultiSelectRow : View {
    
    var friend: User
    @Binding var selectedItems: [String]
    var isSelected: Bool {
        selectedItems.contains(where: { $0 == friend._id })
    }

    var body: some View {
        HStack {
            Text(self.friend.username)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.blue)
            }
        }
        .background(Rectangle().fill(Color(UIColor.systemBackground)))
        .onTapGesture {
            if self.isSelected {
                self.selectedItems.removeAll{$0 == friend._id}
            } else {
                self.selectedItems.append(friend._id)
            }
        }
    }
}
