//
//  SettingsView.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/17/21.
//

import SwiftUI
import FirebaseStorage

struct SettingsView: View {
    @ObservedObject var vm = ViewModel()
    @State var username = [String]()
    @State var urlString = "https://matchmovie.xyz/privacy-policy.html"
    @State var contactUsUrlString = "https://matchmovie.xyz/contact.html"
    @State var showSafari = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: UIImage?
    @State private var image_loading : Bool = false
    @State private var uploading : Bool = false
    @State private var uploadError : Bool = false

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage("isNotificationRight") var isNotificationRight: Bool = false
    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = inputImage
        image_loading = false
        uploading = true
        if let imageData = inputImage.jpegData(compressionQuality: 0.1) {
            let storage = Storage.storage()
            let image_name = "\(user_mongo_id) \("_profile_img")"
            storage.reference().child(image_name).putData(imageData, metadata: nil) {
                (_, err) in
                if let _ = err {
                    uploadError = true
                    uploading = false
                } else {
                    uploading = false
                }
            }
        } else {
            uploadError = true
            uploading = false
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        HStack {
                            if image != nil {
                                Image(uiImage: image!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                                    .onTapGesture {
                                        self.showingImagePicker = true
                                    }
                            } else {
                                Image("avatar1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                                    .onTapGesture {
                                        self.showingImagePicker = true
                                    }
                            }
                        }
                        .padding()
                        if image_loading == true {
                            Text("loading ...")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        if uploading == true {
                            Text("uploading ...")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        if uploadError == true {
                            Text("An error occurred during the upload.\nPlase try again")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    Form {
                        Section(header: Text("User Information")) {
                            if vm.user != nil {HStack {
                                Text("FirstName")
                                Spacer()
                                Text(vm.user!.firstName)
                                    .foregroundColor(Color.secondary)
                            }
                            HStack {
                                Text("LastName")
                                Spacer()
                                Text(vm.user!.lastName)
                                    .foregroundColor(Color.secondary)
                            }
                            HStack {
                                Text("Email")
                                Spacer()
                                Text(vm.user!.email)
                                    .foregroundColor(Color.secondary)
                            }}
                            HStack {
                                NavigationLink(destination: UpdateUsernameView(username: username.count >= 1 ? username[0] : "")) {
                                    Text("Username")
                                    Spacer()
                                    Text(username.count >= 1 ? username[0] : "")
                                        .foregroundColor(Color.secondary)
                                }
                            }
                        }
                        Section(header: Text("App Information")) {
                            Picker(selection: $isNotificationRight, label: Text("Receive notifications")) {
                                Text("Yes").tag(true)
                                Text("No").tag(false)
                            }
                            Button(action: {
                                self.showSafari = true
                            }) {
                                Text("Privacy Policy")
                                    .foregroundColor(Color.primary)
                                    .padding(.bottom, 0)
                            }
                            .sheet(isPresented: $showSafari) {
                                SafariView(url:URL(string: self.urlString)!)
                            }
                            Button(action: {
                                self.showSafari = true
                            }) {
                                Text("Contact Us")
                                    .foregroundColor(Color.primary)
                                    .padding(.bottom, 0)
                            }
                            .sheet(isPresented: $showSafari) {
                                SafariView(url:URL(string: self.contactUsUrlString)!)
                            }
                            HStack {
                                Button(action: {
                                    UserDefaults.standard.removeObject(forKey: "user")
                                    self.mode.wrappedValue.dismiss()
                                }) {
                                    Text("Log out")
                                        .foregroundColor(.red)
                                }
                            }
                            HStack {
                                Button(action: {
                                    deleteUser()
                                }) {
                                    Text("Remove Account")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                Spacer()
                Text("Match Movie v1.8")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
                Text("Made in Los Angeles")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)

            }
            .onAppear {
                self.vm.getUserInfo()
                Auth_Api().get_userInfo(user_id: user_mongo_id) { (userInfo) in
                    self.username = userInfo
                    let image_name = "\(user_mongo_id) \("_profile_img")"
                    image_loading = true
                    Storage.storage().reference().child(image_name).getData(maxSize: 4 * 1024 * 1024) {
                        (imageData, err) in
                        if let err = err {
                            print("An error occured - \(err.localizedDescription)")
                            image_loading = false
                        } else {
                            if let imageData = imageData {
                                image_loading = false
                                self.image = UIImage(data: imageData)
                            } else {
                                print("couldn't get image profile")
                                image_loading = false
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        self.mode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    private func deleteUser() {
        Auth_Api().delete_user(user_id: user_mongo_id) { (result, error) in
            if (result != nil) {
                UserDefaults.standard.removeObject(forKey: "user")
                let image_name = "\(user_mongo_id) \("_profile_img")"
                let desertRef = Storage.storage().reference().child(image_name)
                desertRef.delete { _ in
                }
                self.mode.wrappedValue.dismiss()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
