//
//  AddGroupView.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/5/21.
//

import SwiftUI

struct AddGroupView: View {
    @State var group_title = ""
    @State var selectionType = "movie"
    @State var submit = false
    @State var submitFailed = false
    @State var alertNeedUpdate = false
    @State var submitFailedUser = false
    @State var selectedServiceRows : [String] = []
    @State var selectedGenreRows : [String] = []
    @State var selectedRows : [String] = []

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Group title")) {
                        TextField("Group title", text: $group_title)
                    }
                    Section(header: Text("Group info")) {
                        NavigationLink(destination: SelectServiceForGroupView(selectedServiceRows: $selectedServiceRows)) {
                            Text("\(selectedServiceRows.count > 0 ? "\(selectedServiceRows.count) service\(selectedServiceRows.count > 1 ? "s" : "") selected" : "Select a service")")
                        }
                        Picker(selection: $selectionType, label: Text("Select a type")) {
                            Text("Movies").tag("movie")
                            Text("Tv shows").tag("tvshow")
                        }
                        NavigationLink(destination: SelectGenreForGroupView(selectedGenreRows: $selectedGenreRows)) {
                            Text("\(selectedGenreRows.count > 0 ? "\(selectedGenreRows.count) genre\(selectedGenreRows.count > 1 ? "s" : "") selected" : "Select a genre")")
                        }
                        NavigationLink(destination: SelectUserForGroupView(selectedRows: $selectedRows)) {
                            Text("\(selectedRows.count > 0 ? "\(selectedRows.count) friend\(selectedRows.count > 1 ? "s" : "") selected" : "Select a friend")")
                        }
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button(action: {
                                onAdd()
                            }) { Text("Create") }
                            .alert(isPresented: $submitFailed) {
                                if (submitFailedUser == true) {
                                    return Alert(
                                        title: Text("Your group hasn't been created"),
                                        message: Text("Please add some friends to this group"),
                                        dismissButton: Alert.Button.default(
                                            Text("Ok"), action: { self.submitFailed = false; self.submit = false; submitFailedUser = false}
                                        ))
                                }
                                else if (alertNeedUpdate == true) {
                                    return Alert(
                                        title: Text("Please update the app"),
                                        message: Text("Your group hasn't been created"),
                                        dismissButton: Alert.Button.default(
                                            Text("Ok"), action: { self.submitFailed = false; self.alertNeedUpdate = false }
                                        ))
                                }
                                else {
                                    return Alert(
                                        title: Text("Your group hasn't been created"),
                                        message: Text("Please fill up and select every field to create your new group"),
                                        dismissButton: Alert.Button.default(
                                            Text("Ok"), action: { self.submitFailed = false; self.submit = false }
                                        ))
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("Create a new group", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            self.mode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    func onAdd() {
        if (group_title == "") {
            self.submitFailed.toggle()
            return
        }
        if (selectedServiceRows.count <= 0) {
            self.submitFailed.toggle()
            return
        }
        if (selectedRows.count <= 0) {
            self.submitFailed.toggle()
            self.submitFailedUser.toggle()
            return
        }
        Group_Api().post_group(
            title: group_title,
            user: user_mongo_id,
            friends: selectedRows,
            type: selectionType,
            services: selectedServiceRows,
            selectedGenreRows: selectedGenreRows
        ) { (result, error) in
            if (result != nil) {
                let msg_error = result?["needUpdate"] ?? "undefined"
                if (msg_error as! String != "undefined") {
                    self.submitFailed.toggle()
                    self.alertNeedUpdate.toggle()
                }
                else {
                    self.mode.wrappedValue.dismiss()
                }
            }
            if (error != nil) {
                self.submitFailed.toggle()
            }
        }
    }
}

struct AddGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddGroupView()
    }
}
