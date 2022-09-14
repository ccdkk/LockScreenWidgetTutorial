//
//  lockScreen.swift
//  lockScreen
//
//  Created by 최동권 on 2022/08/30.
//

import WidgetKit
import SwiftUI

let currentTime = Calendar.current.date(byAdding: .second, value: 600, to: Date())
let currentTime1 = Date()
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), seconds: 0.0, nowDate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), seconds: 0, nowDate: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        var seconds: Double = 600
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 10 {
            seconds -= 60
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, seconds: seconds, nowDate: currentDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let seconds: Double
    let nowDate: Date
}

struct lockScreenEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
//        Text(entry.date.addingTimeInterval(50), style: .timer)
        switch family {
        case .accessoryCircular:
            ProgressView(timerInterval: Date()...Date().addingTimeInterval(50),
                         countsDown: false) {
               Image("example30")
                    .resizable()
                    .frame(width:30,height:30)
            }
                         .progressViewStyle(.circular)
        case .accessoryRectangular:
//            let currentTime = Date()
//            let end = Date().addingTimeInterval(15)
//            ProgressView(timerInterval: Date()...Date().addingTimeInterval(15)) {
//                Image("AppText")
//            } currentValueLabel: {
//                Text(entry.date.addingTimeInterval(-15), style: .timer)
//            }
//            .progressViewStyle(.linear)
            
            HStack{
                ProgressView(timerInterval: currentTime1...currentTime!,
                countsDown: false) {
                    HStack{
                        Image("AppText")
                        Spacer()
                        Text("\(Int(entry.seconds / 60))")
                    }
                } currentValueLabel: {
                    
                }
                .progressViewStyle(.linear)
                
            }
            
//            Text(entry.date.formatMinute())
        default:
            EmptyView()
        }
    }
}

@main
struct lockScreen: Widget {
    let kind: String = "lockScreen"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            lockScreenEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

struct lockScreen_Previews: PreviewProvider {
    static var previews: some View {
        lockScreenEntryView(entry: SimpleEntry(date: Date(), seconds: 0.0, nowDate: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("circular")
    }
}

extension Date {
    func formatMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let str = formatter.string(from: self)
        
        return str
    }
}


