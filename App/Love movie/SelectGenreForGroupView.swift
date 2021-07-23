//
//  SelectGenreForGroupView.swift
//  Match Movie
//
//  Created by Antoine Boudet on 3/24/21.
//

import Foundation
import SwiftUI

struct SelectGenreForGroupView: View {
    @State var new_user = ""
    @State var isPeopleChosen = false
//    @State var selectedRows : [String] = []
    @Binding var selectedGenreRows : [String]
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
                    MultiSelectRowForGenre(genre: "Comedy", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Drama", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Thriller", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Action & Adventure", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Family", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Romance", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Animation", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Biography", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Documentary", selectedGenreRows: self.$selectedGenreRows)
                    MultiSelectRowForGenre(genre: "Crime", selectedGenreRows: self.$selectedGenreRows)
                }
                Spacer()
            }
            Spacer()
            if (selectedGenreRows.count >= 1) {
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
        .navigationBarTitle("\(selectedGenreRows.count) friend\(selectedGenreRows.count > 1 ? "s" : "") selected", displayMode: .inline)
    }
}

//struct SelectGenreForGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectGenreForGroupView()
//    }
//}

struct MultiSelectRowForGenre : View {
    
    var genre: String
    @Binding var selectedGenreRows: [String]
    var isSelected: Bool {
        selectedGenreRows.contains(where: { $0 == genre })
    }

    var body: some View {
        HStack {
            Text(self.genre)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.blue)
            }
        }
        .background(Rectangle().fill(Color(UIColor.systemBackground)))
        .onTapGesture {
            if self.isSelected {
                self.selectedGenreRows.removeAll{$0 == genre}
            } else {
                self.selectedGenreRows.append(genre)
            }
        }
    }
}
