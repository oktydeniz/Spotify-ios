//
//  Extension.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation
import UIKit

extension UIView {
    var width:CGFloat {
        return frame.size.width
    }
    
    var height:CGFloat {
        return frame.size.height
    }
    
    var left:CGFloat {
        return frame.origin.x
    }
    
    var right:CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom:CGFloat {
        return top + height
    }
}


extension DateFormatter {
    static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension String {
    static func formattedDate(str: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: str) else {
            return str
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
