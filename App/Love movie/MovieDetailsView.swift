//
//  MovieDetailsView.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/19/21.
//

import SwiftUI

struct MovieDetailsView: View {
    @State var movie : Movie
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: .topTrailing) {
            content
            CloseButton()
                .padding()
                .onTapGesture {
                    self.mode.wrappedValue.dismiss()
                }
        }
    }
    var content: some View {
        ScrollView {
            VStack {
                HStack {
                    RemoteImage(url: movie.img)
                        .frame(width: 150, height: 270)
                        .cornerRadius(10)
                        .padding()
                    Spacer()
                    VStack {
                        Text(movie.title)
                            .font(.title)
                            .bold()
                            .padding()
                        HStack {
                            Text(movie.duration)
                            Text("(\(movie.dateCreated))")
                        }
                    }
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("Description:")
                            .font(.headline)
                        Spacer()
                    }
                    HStack {
                        Text(movie.description)
                            .font(.footnote)
                        Spacer()
                    }
                    .padding(.top, 5)
                }
                .padding()

                VStack {
                    HStack {
                        Text("Categories:")
                            .font(.headline)
                        Spacer()
                    }
                    HStack {
                        Text(movie.genres)
                            .font(.footnote)
                        Spacer()
                    }
                    .padding(.top, 2)
                }
                .padding()
                Spacer()
            }
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie(id: "", type: "Action", title: "James Bond", img: "https://img.reelgood.com/content/movie/02d8a34b-0568-4157-9749-94778e400dce/poster-780.jpg", description: "cdcdcercveve fv fd df fd df", grade: "18+", genres: "Action", rated: "18+", dateCreated: "", duration: "2h", tags: "tag", country: "US", servicesLink: "", services: [Service(_id: "", title: "", label: "")], offset: 1, nb_current_picture: 0))
    }
}
