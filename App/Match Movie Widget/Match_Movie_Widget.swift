//
//  Match_Movie_Widget.swift
//  Match Movie Widget
//
//  Created by Antoine Boudet on 3/9/21.
//

import WidgetKit
import SwiftUI
import Intents

struct UserEntry: TimelineEntry {
    let date: Date
    let user: AuthUserFullData
    let widgetInfo: WidgetInformation
}

struct Provider: IntentTimelineProvider {
    
    @AppStorage("user", store: UserDefaults(suiteName: "group.match-movie"))
    var userData: Data = Data()
    
    func placeholder(in context: Context) -> UserEntry {
        UserEntry(date: Date(), user: AuthUserFullData(_id: "603f9855035b7df6b89cefa2", userId: "000480.8b4a33d7d23a4b53b898f1c920b13dee.1749", firstName: "test", lastName: "Test", email: "test@gmail.com", authState: "authorized"), widgetInfo: WidgetInformation(title: "Test", match_movie: [SmallMovie(id: "1", title: "Toys", img: "String"), SmallMovie(id: "2", title: "The intouchable", img: "")], services: [Service(_id: "netflix", title: "netflix", label: "netflix")]))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (UserEntry) -> ()) {
        guard let user = try? JSONDecoder().decode(AuthUserFullData.self, from: userData) else { return }
        Group_Api().get_widget_informations(user_id: user._id) { (data) in
            let entry = UserEntry(date: Date(), user: user, widgetInfo: data[0])
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        guard let user = try? JSONDecoder().decode(AuthUserFullData.self, from: userData) else { return }
        Group_Api().get_widget_informations(user_id: user._id) { (data) in
            let entry = UserEntry(date: Date(), user: user, widgetInfo: data[0])
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }

    }
}

struct Match_Movie_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if family == .systemSmall {
            MatchMovieWidgetSmall(entry: entry)
        } else if family == .systemMedium {
            MatchMovieWidgetMedium(entry: entry)
        } else {
            MatchMovieWidgetLarge(entry: entry)
        }
    }
}

struct MatchMovieWidgetSmall: View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("New match")
                .font(Font.footnote.smallCaps())
                .foregroundColor(.secondary)
            HStack {
                if (entry.widgetInfo.services.count > 0) {
                    Image("black_img")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                } else {
                    Image(entry.widgetInfo.services[0].title)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                }
                Text(entry.widgetInfo.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            HStack {
                Spacer()
                Text("\(entry.widgetInfo.match_movie.count)")
                    .font(.largeTitle)
                Spacer()
            }
            .padding()
            HStack(spacing: 3) {
                Text("Last checked:")
                    .font(Font.system(size: 8, design: .default))
                Text(entry.date, style: .time)
                    .font(Font.system(size: 8, design: .default))
            }
        }
        .padding(12)
    }
}

struct MatchMovieWidgetMedium: View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("New match")
                .font(Font.footnote.smallCaps())
                .foregroundColor(.secondary)
            HStack {
                if (entry.widgetInfo.services.count > 0) {
                    Image("black_img")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                } else {
                    Image(entry.widgetInfo.services[0].title)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                }
                Text(entry.widgetInfo.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            HStack {
                if (entry.widgetInfo.match_movie.count > 0) {
                    ForEach(entry.widgetInfo.match_movie.indices) { index in
                        if (index <= 5) {
                            URLImageView(url: URL(string: entry.widgetInfo.match_movie[index].img)!)
                                .frame(width: 50, height: 70)
                        }
                    }
               }
                else {
                    Text("No match for this group yet")
                        .padding(.top, 10)
                }
                Spacer()
            }
            .padding(.top, 5)
            HStack {
                Spacer()
                Text("Last checked:")
                    .font(Font.system(size: 10, design: .default))
                Text(entry.date, style: .time)
                    .font(Font.system(size: 10, design: .default))
            }
        }
        .padding()
    }
}

struct MatchMovieWidgetLarge: View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("New match")
                .font(Font.footnote.smallCaps())
                .foregroundColor(.secondary)
            HStack {
                if (entry.widgetInfo.services.count > 0) {
                    Image("black_img")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                } else {
                    Image(entry.widgetInfo.services[0].title)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                }
                Text(entry.widgetInfo.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            HStack {
                if (entry.widgetInfo.match_movie.count > 0) {
                    ForEach(entry.widgetInfo.match_movie.indices) { index in
                        if (index <= 1) {
                            URLImageView(url: URL(string: entry.widgetInfo.match_movie[index].img)!)
                                .frame(width: 150, height: 250)
                        }
                    }
               }
                else {
                    Text("No match for this group yet")
                        .padding(.top, 40)
                }
                Spacer()
            }
            .padding(.top, 20)
            Spacer()
            HStack {
                Spacer()
                Text("Last checked:")
                    .font(Font.system(size: 10, design: .default))
                Text(entry.date, style: .time)
                    .font(Font.system(size: 10, design: .default))
            }
        }
        .padding()
    }
}
@main
struct Match_Movie_Widget: Widget {
    let kind: String = "Match_Movie_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Match_Movie_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("See your match")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct Match_Movie_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Match_Movie_WidgetEntryView(entry: UserEntry(date: Date(), user: AuthUserFullData(_id: "603f9855035b7df6b89cefa2", userId: "000480.8b4a33d7d23a4b53b898f1c920b13dee.1749", firstName: "test", lastName: "Test", email: "test@gmail.com", authState: "authorized"), widgetInfo: WidgetInformation(title: "Test", match_movie: [SmallMovie(id: "1", title: "Toys", img: "String"), SmallMovie(id: "2", title: "The intouchable", img: "")], services: [Service(_id: "netflix", title: "netflix", label: "netflix")])))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
