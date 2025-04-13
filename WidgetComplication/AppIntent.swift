//
//  AppIntent.swift
//  WidgetComplication
//
//  Created by Alexia Nunez on 4/12/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Favorite gym capacity" }
    static var description: IntentDescription { "Shows the current gym capacity." }

    // An example configurable parameter.
    @Parameter(title: "Capacity", default: 50)
    var capacity: Double
}
