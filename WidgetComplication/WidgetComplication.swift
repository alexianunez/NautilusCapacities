//
//  WidgetComplication.swift
//  WidgetComplication
//
//  Created by Alexia Nunez on 4/12/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    private let apiClient = APIClient.shared
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), occupancy: 50)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, occupancy: 50)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        do {
            let branches = try await apiClient.fetchBranches().sorted { $0.description.trimmingCharacters(in: .whitespacesAndNewlines) < $1.description.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            let branch = branches.first(where: { FavoritesManager.shared.isFavorite($0)}) ?? branches.first
            
            guard let branch else {
                return Timeline(entries: [], policy: .atEnd)
            }
                        
            let entry = SimpleEntry(
                date: currentDate,
                configuration: configuration,
                occupancy: branch.occupancy
            )
            entries.append(entry)
            
            // CHANGE: Update more frequently
            return Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(300))) // 5 minutes

        } catch {
            return Timeline(entries: [], policy: .atEnd)
        }
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Favorite Gym Capacity")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var occupancy: Int = 50
}

struct WidgetComplicationEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            CircularProgressView(
                progress: Double(entry.occupancy) / 100.0
            )
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        VStack {
            
        }
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .butt
                        )
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))")
                .font(.system(.title2, design: .rounded))
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
        .configurationDisplayName("Gym Capacity")
        .description("Shows your favorite gym's capacity")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
        .contentMarginsDisabled()
    }
}

#Preview(as: .accessoryRectangular) {
    WidgetComplication()
} timeline: {
    SimpleEntry(date: .now,
                configuration: ConfigurationAppIntent(),
                occupancy: 25)
}
