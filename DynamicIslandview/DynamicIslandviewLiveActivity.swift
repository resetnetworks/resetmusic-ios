//
//  DynamicIslandviewLiveActivity.swift
//  DynamicIslandview
//
//  Created by Naushad Ali Khan on 17/03/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicIslandviewLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicPlayerAttributes.self) { _ in
            EmptyView()
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { }
                DynamicIslandExpandedRegion(.trailing) { }
                DynamicIslandExpandedRegion(.bottom) { }
            } compactLeading: { } compactTrailing: { } minimal: { }
        }
    }
}
