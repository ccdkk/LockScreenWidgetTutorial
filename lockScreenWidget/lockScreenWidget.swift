//
//  lockScreenWidget.swift
//  lockScreenWidget
//
//  Created by 최동권 on 2022/08/25.
//
//
//
//  lockScreen.swift
//  lockScreen
//
//  Created by 최동권 on 2022/08/30.
//

import WidgetKit
import SwiftUI

let currentTime = Calendar.current.date(byAdding: .second, value: 10, to: Date())
let currentTime1 = Date()
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), seconds: 0.0, nowDate: Date(), endDate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), seconds: 0, nowDate: Date(), endDate: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        if var seconds = UserDefaults(suiteName: "group.ccdkk")?.value(forKey: "lockScreen") as? Double {
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            let endDate = Calendar.current.date(byAdding: .second, value: Int(seconds), to: currentDate)
            var plusSeconds: Double = -1
//            let refreshDate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!
            
            while seconds >= 0 {
                let entryDate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!
                let entry = SimpleEntry(date: currentDate + plusSeconds, seconds: seconds, nowDate: currentDate, endDate: endDate!)
                seconds -= 1
                plusSeconds += 1
                entries.append(entry)
            }
//            UserDefaults(suiteName: "group.ccdkk")?.set(20, forKey: "lockScreen")
            let timeline = Timeline(entries: entries, policy: .never)

            completion(timeline)
            
        } else {
            let entry = SimpleEntry(date: Date(), seconds: 0, nowDate: Date(), endDate: Date() + 3)
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
        
        
        
        
//        if seconds <= 0 {
//            let entryDate = Calendar.current.date(byAdding: .minute, value: 2, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, seconds: 0, nowDate: currentDate)
//            let timeline = Timeline(entries: [entry], policy: .never)
//            completion(timeline)
//        }
//        for hourOffset in 0 ..< 10 {
//            print(currentDate)
//            seconds -= 60
//            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, seconds: seconds, nowDate: currentDate)
//            entries.append(entry)
//        }
        
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let seconds: Double
    let nowDate: Date
    let endDate: Date
}

struct lockScreenEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
//        Text(entry.date.addingTimeInterval(50), style: .timer)
        switch family {
        case .accessoryCircular:
            ProgressView(timerInterval: Date()...Date().addingTimeInterval(50),
                         countsDown: true) {
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
                ProgressView(timerInterval: entry.nowDate...entry.endDate,
                countsDown: true) {
                    HStack{
                        Image("AppText")
                        Spacer()
                        Text("\(Int(entry.seconds)) min")
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
        lockScreenEntryView(entry: SimpleEntry(date: Date(), seconds: 0.0, nowDate: Date(), endDate: Date()))
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




//원본
//import WidgetKit
//import SwiftUI
//import Intents
//
//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        let endDate = Date().addingTimeInterval(10)
//        let oneMinute: TimeInterval = 1
//        var currentDate = Date()
//        var entries: [SimpleEntry] = []
//
//        while currentDate < endDate {
//            let entry = SimpleEntry()
//
//            currentDate += oneMinute
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .never)
//
//        completion(timeline)
//    }
//
////    func setupBool() -> Timeline<SimpleEntry>{
////        let entry: SimpleEntry
////
////        if let widgetData = UserDefaults(suiteName: "group.ccdkk")!.value(forKey: "lockScreen") {
////            entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), isOn: widgetData as! Bool)
////        } else {
////            entry = SimpleEntry()
////        }
////
////        return Timeline(entries: [entry], policy: .atEnd)
////    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationIntent
//    var isOn = false
//
//    init(date: Date = Date(), configuration: ConfigurationIntent = ConfigurationIntent(), isOn: Bool = false) {
//        self.date = date
//        self.configuration = configuration
//        self.isOn = isOn
//    }
//}
//
//struct lockScreenWidgetEntryView : View {
//    @Environment(\.widgetFamily) var widgetFamily
//    @State private var isStop: Bool?
//    var entry: Provider.Entry
//
//    @ViewBuilder
//    var body: some View {
//        switch widgetFamily {
//
//        case .accessoryInline:
//            Text(entry.date, format: .dateTime)
//
//        case .accessoryCircular:
//
////                Gauge(value: 0.5) {
////
//////                    if isStop ?? true {
////                    Text(Date().addingTimeInterval(20), style: .timer)
//////                    } else {
//////                        Text("0:00")
//////                    }
////                } currentValueLabel: {
////                    Image("AppText")
////                }
////                .gaugeStyle(.accessoryCircular)
////
////            ProgressView(value: 0.5) {
////                Image("AppText")
////            }.progressViewStyle(.circular)
////
//            let currentTime = Date()
//            let end = Date().addingTimeInterval(15)
//            ProgressView(timerInterval: currentTime...end) {
//
//            }.progressViewStyle(.linear)
//                .frame(maxWidth: 100, maxHeight: 100)
//
//
//
//        case .accessoryRectangular:
//            let currentTime = Date()
//            let end = Date().addingTimeInterval(15)
//            ProgressView(timerInterval: entry.date...entry.date.addingTimeInterval(15)) {
//                Image("AppText")
//            } currentValueLabel: {
//
//            }
//            .progressViewStyle(.linear)
//
//        default:
//            Text("not implemented")
//        }
//
//
//    }
//
//     func nextRollTime(in seconds: Int) -> Date {
//
//        let date = Calendar.current.date(byAdding: .second, value: seconds, to: Date())
//              DispatchQueue.main.asyncAfter(deadline: .now() + Double(seconds)) {
//                  self.isStop = false
//              }
//         return date ?? Date()
//    }
//}
//
//@main
//struct lockScreenWidget: Widget {
//    let kind: String = "lockScreenWidget"
//
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//            lockScreenWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
//    }
//}
////
////struct lockScreenWidget_Previews: PreviewProvider {
////    static var previews: some View {
////        lockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
////            .previewContext(WidgetPreviewContext(family: .accessoryInline))
////            .previewDisplayName("inline")
////
////        lockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
////            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
////            .previewDisplayName("Circular")
////
////        lockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
////            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
////            .previewDisplayName("Rectangular")
////    }
////}
