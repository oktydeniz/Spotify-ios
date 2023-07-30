//
//  HapticsManager.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation
import UIKit

final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init(){}
    
    public func vibratareForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibratare(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
