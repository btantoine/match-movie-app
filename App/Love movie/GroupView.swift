//
//  GroupView.swift
//  Love movie
//
//  Created by Antoine Boudet on 1/15/21.
//
    
import SwiftUI
import UserNotifications

struct GroupView: View {
    @State var groups: [Group] = []
    @State var editMode = EditMode.inactive
    private static var count = 0
    @State var showingProfileSettings = false
    @State var showingCategory = false
    @State var showingMacthes = false
    @State var showSafari = false
    @State private var showingAddGroup = false
    @State var alertNotAdmin = false
    @State var isLoading = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"
    @AppStorage("checkNotificationRight") var checkNotificationRight: Bool = false
    @AppStorage("isNotificationRight") var isNotificationRight: Bool = false

    // Notification
    @StateObject var notificationDelegate = NotificationDelegate()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading == false {
                    contentView
                }
                else if isLoading == true {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                }
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        checkNotificationRight = true
                        isNotificationRight = true
                    } else {
                        checkNotificationRight = true
                        isNotificationRight = false
                    }
                }
                UNUserNotificationCenter.current().delegate = notificationDelegate
                isLoading = true
                Group_Api().get_groups(user_id: user_mongo_id) { (groups) in
                    self.groups = groups
                    isLoading = false
                    Group_Api().get_groups_by_invitation(user_id: user_mongo_id) { (groups) in
                        var check = false
                        for group in groups {
                            check = false
                            for self_group in self.groups {
                                if self_group._id == group._id {
                                    check = true
                                }
                            }
                            if (check == false) {
                                self.groups.append(group)
                            }
                            if (isNotificationRight == true) {
                                createNotification(title: "Group invitation", subtitle: "You have been invited in \"\(group.title)\" group")
                            }
                        }
                    }
                }
            }
            .onReceive(timer) { time in
                Group_Api().get_groups(user_id: user_mongo_id) { (groups) in
                    var check = false
                    for group in groups {
                        check = false
                        for self_group in self.groups {
                            if self_group._id == group._id {
                                check = true
                            }
                        }
                        if (check == false) {
                            self.groups.append(group)
                        }
                    }
                    Group_Api().get_groups_by_invitation(user_id: user_mongo_id) { (groups) in
                        var check = false
                        for group in groups {
                            check = false
                            for self_group in self.groups {
                                if self_group._id == group._id {
                                    check = true
                                }
                            }
                            if (check == false) {
                                self.groups.append(group)
                            }
                            if (isNotificationRight == true) {
                                createNotification(title: "Group invitation", subtitle: "You have been invited in \"\(group.title)\" group")
                            }
                        }
                    }
                }
                
                // Check for match
                Group_Api().get_match(user_id: user_mongo_id) { (match) in
                    if (match.count >= 1 && isNotificationRight == true) {
                        createNotification(title: "You just got a new movie match for the group\(match.count == 0 ? "": "s"):", subtitle: "\(match[0])")
                    }
                }
                
            }
            .navigationBarTitle("My Groups", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {self.showingProfileSettings.toggle()}, label: {
                        Image("menu")
                            .renderingMode(.template)
                    })
                    .sheet(isPresented: $showingProfileSettings) {
                        SettingsView()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {self.showingAddGroup.toggle()}, label: {
                        Image(systemName: "plus.app")
                    })
                    .sheet(isPresented: $showingAddGroup) {
                        AddGroupView()
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    func createNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "LoveMovieAppTest", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    private func onDelete(offsets: IndexSet) {
        Group_Api().delete_group(user_id: user_mongo_id,
            _id: groups[offsets.first!]._id
        ) { (result, error) in
            if (result != nil) {
                let msg_error = result?["notadmin"] ?? "undefined"
                if (msg_error as! String != "undefined") {
                    self.alertNotAdmin = true
                }
                else {
                    groups.remove(atOffsets: offsets)
                }
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }

    var addGroupView: some View {
        ZStack {
            AddGroupView()
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(false)
        }
    }
    
    var contentView: some View {
        VStack {
        if (checkNotificationRight == false) {
            VStack {
                Button("Notification request permission") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            checkNotificationRight = true
                            isNotificationRight = true
                        } else if let error = error {
                            checkNotificationRight = true
                            isNotificationRight = false
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        else if (groups.count <= 0) {
            VStack {
                Spacer()
                Text("You haven't created any group or have been invited in one yet! Create a new one to have some fun")
                    .padding(.bottom, 30)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    .font(.body)
                Button(action: {self.showingAddGroup.toggle()}, label: {
                    Text("Create a new group")
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                })
                .sheet(isPresented: $showingAddGroup) {
                    AddGroupView()
                }
                Spacer()
            }
        } else {
                List {
                    ForEach(groups) { group in
                        NavigationLink(destination: (
                            ZStack {
                                ContentView(group_id: group._id)
                                    .navigationBarTitle(group.title, displayMode: .inline)
                                    .toolbar {
                                        NavigationLink(destination: (
                                            ZStack {
                                                GroupDetailView(group: group, friends: group.friends)
                                                    .navigationBarTitle("", displayMode: .inline)
                                                    .navigationBarHidden(false)
                                            }
                                        )) {
                                            Text("Details")
                                        }
                                    }
                            }
                        )) {
                            HStack {
                                if group.services.count > 1 {
                                    ZStack {
                                        Image("black_img")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(50.0)
                                        VStack {
                                            Text("\(group.services.count)")
                                                .font(Font.system(size: 20, design: .rounded))
                                                .foregroundColor(.white)
                                            Text("services")
                                                .font(Font.system(size: 8, design: .rounded))
                                                .foregroundColor(.white)
                                        }
                                    }
                                } else {
                                    Image(group.services[0].title)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(50.0)
                                }
                                VStack {
                                    HStack {
                                        Text(group.title)
                                            .bold()
                                        Spacer()
                                    }
                                }
                                .padding(.leading, 10)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: onDelete)
                }
                .alert(isPresented: $alertNotAdmin) {
                    Alert(
                        title: Text("You didn't create this group"),
                        message: Text("To remove a group, you need to be the one you created it at first"))
                }
            }
        }
    }
}


struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}


class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier,
                 UNNotificationDismissActionIdentifier:
                break
            default:
                break
      }
    }
}
