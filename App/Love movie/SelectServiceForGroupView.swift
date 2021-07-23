//
//  SelectServiceForGroupView.swift
//  Match Movie
//
//  Created by Antoine Boudet on 3/24/21.
//

import Foundation
import SwiftUI

struct SelectServiceForGroupView: View {
    @State var new_user = ""
    @State var isPeopleChosen = false
//    @State var selectedServiceRows : [String] = []
    @Binding var selectedServiceRows : [String]
    @State var alert = false
    @State var alertNewFriend = false
    @State var alertNotMyself = false
    @State var isLoading = false

    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            if isLoading == false {
                List() {
                    MultiSelectRowForService(serviceName: "Netflix", service: "601d566ae0635e0becbc7526", selectedItems: self.$selectedServiceRows)
                    MultiSelectRowForService(serviceName: "Hulu", service: "601d5668e0635e0becbc7525", selectedItems: self.$selectedServiceRows)
                    MultiSelectRowForService(serviceName: "Amazon Prime", service: "601d5666e0635e0becbc7524", selectedItems: self.$selectedServiceRows)
                    MultiSelectRowForService(serviceName: "Disney Plus", service: "601d5665e0635e0becbc7523", selectedItems: self.$selectedServiceRows)
                    MultiSelectRowForService(serviceName: "Apple Tv+", service: "601d5663e0635e0becbc7522", selectedItems: self.$selectedServiceRows)
                    MultiSelectRowForService(serviceName: "Hbo Max", service: "601d5661e0635e0becbc7521", selectedItems: self.$selectedServiceRows)
                    MultiSelectRowForService(serviceName: "Hbo", service: "601d565ce0635e0becbc7520", selectedItems: self.$selectedServiceRows)
                }
                Spacer()
            }
            Spacer()
            if (selectedServiceRows.count >= 1) {
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
        }
        .alert(isPresented: $isPeopleChosen) {
            Alert(
                title: Text("You didn't choose a friend(s)"),
                message: Text("Please select someone in your list or add a new one by using the text field"))
        }
        .navigationBarTitle("\(selectedServiceRows.count) friend\(selectedServiceRows.count > 1 ? "s" : "") selected", displayMode: .inline)
    }
}

//struct SelectServiceForGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectServiceForGroupView()
//    }
//}

struct MultiSelectRowForService : View {
    
    var serviceName: String
    var service: String
    @Binding var selectedItems: [String]
    var isSelected: Bool {
        selectedItems.contains(where: { $0 == service })
    }

    var body: some View {
        HStack {
            Text(self.serviceName)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.blue)
            }
        }
        .background(Rectangle().fill(Color(UIColor.systemBackground)))
        .onTapGesture {
            if self.isSelected {
                self.selectedItems.removeAll{$0 == service}
            } else {
                self.selectedItems.append(service)
            }
        }
    }
}
