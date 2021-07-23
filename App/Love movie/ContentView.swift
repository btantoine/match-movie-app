//
//  ContentView.swift
//  Love movie
//
//  Created by Antoine Boudet on 1/15/21.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    @State var list_movie = [Movie]()
    @State var group_id: String
    @State var isLoading = false
    @State var nb_picture_to_display: Int = 0
    @Environment(\.openURL) var openURL
    
    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"

    var body: some View {
        ZStack {
            if isLoading == false {
                Home(profiles: list_movie, group_id: group_id, nb_picture_to_display: $nb_picture_to_display)
            }
            else if isLoading == true {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            }
        }
        .onAppear {
            isLoading = true
            Group_Api().get_list_movie_by_groups_id(group_id: group_id, user_id: user_mongo_id) { (data_list_movie) in
                list_movie = data_list_movie
                isLoading = false
                nb_picture_to_display = (data_list_movie.count == 0) ? 0 : data_list_movie[0].nb_current_picture + 10
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(group_id: "")
    }
}

struct Home : View {
    var profiles: [Movie]
    var group_id: String
    @State var showingProfileSettings = false
    @State var showingCategory = false
    @State var showingMacthes = false
    @State var showSafari = false
    @State var urlString = "https://www.buymeacoffee.com/lovemovie"
    @Binding var nb_picture_to_display: Int
    @State var movie_match = [Movie]()

    var body: some View {
        VStack{
            GeometryReader{g in
                ZStack{
                    ForEach(profiles.reversed()) { profile in
                        ProfileView(profile: profile,frame: g.frame(in: .global), group_id: group_id, nb_picture_to_display: $nb_picture_to_display)
                    }
                    .zIndex(2)
                    VStack {
                        Spacer()
                        Text("You played all the movies in your personal list of this group!")
                            .padding(.bottom, 30)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .font(.headline)
                            .font(Font.body.bold())
                        Text("Everybody loves 👇")
                            .font(.headline)
                        Spacer()
                        HStack {
                            if (movie_match.count > 0) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(movie_match) { movie in
                                                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                                                RemoteImage(url: movie.img)
                                                LinearGradient(gradient: .init(colors: [Color.black.opacity(0),Color.black.opacity(0.4)]), startPoint: .center, endPoint: .bottom)
                                                VStack {
                                                    HStack {
                                                        VStack(alignment: .leading) {
                                                            Text(movie.title)
                                                                .font(.body)
                                                                .fontWeight(.bold)
                                                                .padding(.leading, 30)
                                                        }
                                                        .foregroundColor(.white)
                                                        Spacer(minLength: 0)
                                                    }
                                                }
                                                .padding(.all)
                                            })
                                            .frame(width: 200 ,height: 300)
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                            } else {
                                HStack {
                                    Spacer()
                                    Image("nomovie")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(50.0)
                                    Spacer()
                                }
                                .padding(.top, 100)
                            }
                        }
                        .onAppear {
                            Group_Api().get_match_movie_list(group_id: group_id) { (movie_match) in
                                self.movie_match = movie_match
                            }
                        }
                        Spacer()
                        Button(action: {
                            self.urlString = "https://www.buymeacoffee.com/lovemovie"
                            self.showSafari = true
                        }) {
                            Text("Support us")
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 20)
                        .sheet(isPresented: $showSafari) {
                            SafariView(url:URL(string: self.urlString)!)
                        }
                        Text("We are currently working hard to add more cool features to this app. If you want to support us, please follow the link above.")
                            .padding(.bottom, 30)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .font(.footnote)
                    }
                    .zIndex(1)
                }

            }
            .padding([.horizontal,.top,.bottom])
        }
        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.all))
    }
}

struct ProfileView : View {
    @State var profile : Movie
    var frame : CGRect
    var group_id: String
    @Binding var nb_picture_to_display: Int
    @State private var showingMovieDetails = false

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            if (profile.type == "ad") {
                AdView()
                Button(action: {
                    withAnimation(Animation.easeIn(duration: 0.8)){
                        profile.offset = -500
                    };
                    if (profile.nb_current_picture >= nb_picture_to_display - 1) {
                        nb_picture_to_display = nb_picture_to_display + 8
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.all,20)
                        .background(Color("Color"))
                        .clipShape(Circle())
                })
            }
            else if (profile.nb_current_picture < nb_picture_to_display) {
                RemoteImage(url: profile.img)
                    .frame(width: frame.width, height: frame.height)
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    (profile.offset > 0 ? Color.green : Color("Color"))
                        .opacity(profile.offset != 0 ? 0.7 : 0)
                    HStack {
                        if profile.offset < 0 {
                            Spacer()
                        }
                        Text(profile.offset == 0 ? "" : (profile.offset > 0 ? "Liked" : "Disliked"))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 25)
                            .padding(.horizontal)
                        
                        if profile.offset > 0 {
                            Spacer()
                        }
                    }
                })
                LinearGradient(gradient: .init(colors: [Color.black.opacity(0),Color.black.opacity(0.4)]), startPoint: .center, endPoint: .bottom)
                VStack(spacing: 20){
                    HStack{
                        VStack(alignment: .leading,spacing: 12){
                            Text(profile.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(profile.rated + " +")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        Spacer(minLength: 0)
                    }
                    HStack(spacing: 35){
                        Spacer(minLength: 0)
                        Button(action: {
                            withAnimation(Animation.easeIn(duration: 0.8)){
                                profile.offset = -500
                            };
                            if (profile.nb_current_picture >= nb_picture_to_display - 1) {
                                nb_picture_to_display = nb_picture_to_display + 8
                            }
                            if (profile.type != "ad") {
                                Swipe_Api().post_swipe(group_id: group_id, movie_id: profile.id, user_id: user_mongo_id, type: "left") { (result, error) in
                                    if (result != nil) {
                                        let msg_error = result?["nogroup"] ?? "undefined"
                                        if (msg_error as! String != "undefined") {
                                            DispatchQueue.main.async {
                                                self.mode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.all,20)
                                .background(Color("Color"))
                                .clipShape(Circle())
                        })
                        if (profile.type != "ad") {
                            Button(action: {
                                self.showingMovieDetails.toggle()
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.all,20)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            })
                            .sheet(isPresented: $showingMovieDetails) {
                                MovieDetailsView(movie: profile)
                            }
                            Button(action: {
                                withAnimation(Animation.easeIn(duration: 0.8)){
                                    profile.offset = 500
                                };
                                if (profile.nb_current_picture >= nb_picture_to_display - 1) {
                                    nb_picture_to_display = nb_picture_to_display + 8
                                }
                                Swipe_Api().post_swipe(group_id: group_id, movie_id: profile.id, user_id: user_mongo_id, type: "right") { (result, error) in
                                    if (result != nil) {
                                        let msg_error = result?["nogroup"] ?? "undefined"
                                        if (msg_error as! String != "undefined") {
                                            DispatchQueue.main.async {
                                                self.mode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                }
                            }, label: {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.all,20)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            })
                        }
                        Spacer(minLength: 0)
                    }
                }
                .padding(.all)
            }
        })
        .cornerRadius(20)
        .offset(x: profile.offset)
        .rotationEffect(.init(degrees: profile.offset == 0 ? 0 : (profile.offset > 0 ? 12 : -12)))
        .gesture(
            DragGesture()
                .onChanged({ (value) in
                    withAnimation(.default){
                        profile.offset = value.translation.width
                    }
                })
                .onEnded({ (value) in
                    withAnimation(.easeIn) {
                        if profile.offset > 150 {
                            profile.offset = 500
                            if (profile.nb_current_picture >= nb_picture_to_display - 1) {
                                nb_picture_to_display = nb_picture_to_display + 8
                            }
                            if (profile.type != "ad") {
                                Swipe_Api().post_swipe(group_id: group_id, movie_id: profile.id, user_id: user_mongo_id, type: "right") { (result, error) in
                                    if (result != nil) {
                                        let msg_error = result?["nogroup"] ?? "undefined"
                                        if (msg_error as! String != "undefined") {
                                            DispatchQueue.main.async {
                                                self.mode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if profile.offset < -150 {
                            profile.offset = -500
                            if (profile.nb_current_picture >= nb_picture_to_display - 1) {
                                nb_picture_to_display = nb_picture_to_display + 8
                            }
                            if (profile.type != "ad") {
                                Swipe_Api().post_swipe(group_id: group_id, movie_id: profile.id, user_id: user_mongo_id, type: "left") { (result, error) in
                                    if (result != nil) {
                                        let msg_error = result?["nogroup"] ?? "undefined"
                                        if (msg_error as! String != "undefined") {
                                            DispatchQueue.main.async {
                                                self.mode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            profile.offset = 0
                        }
                    }
                })
        )
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
