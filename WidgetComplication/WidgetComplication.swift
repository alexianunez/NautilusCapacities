//
//  WidgetComplication.swift
//  WidgetComplication
//
//  Created by Alexia Nunez on 4/12/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Favorite Gym Capacity")]
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct WidgetComplicationEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            CircularProgressView(
                progress: Double(entry.configuration.capacity) / 100.0
            )
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(.subheadline, design: .rounded))
                .bold()
        }
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.5:
            return .green
        case 0.5..<0.8:
            return .yellow
        default:
            return .red
        }
    }
}

@main
struct WidgetComplication: Widget {
    let kind: String = "WidgetComplication"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var fifty: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.capacity = 50
        return intent
    }
    
    fileprivate static var seventyFive: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.capacity = 75
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    WidgetComplication()
} timeline: {
    SimpleEntry(date: .now, configuration: .fifty)
    SimpleEntry(date: .now, configuration: .seventyFive)
}
