//
//  Constants.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 24/07/22.
//

import Foundation
import UIKit
import SnapKit

var currentUser: User?
var currBigTasks: BigTask?

struct K {
    struct Offset {
        static let topComponent = 100
        static let lg = 28
        static let md = 16
        static let sm = 4
        static let width = 40
    }
    
    struct StatusTask{
        static let notStarted = 0
        static let preview = 1
        static let question = 2
        static let read = 3
        static let reflect = 4
        static let recite = 5
        static let review = 6
        static let done = 7
    }
    
    struct State{
        static let isEditing = 1
        static let isCreating = 2
        static let isViewing = 3
    }
    
    struct FontSize{
        static let vlg : CGFloat = 32
        static let lg : CGFloat = 24
        static let md : CGFloat = 16
        static let sm : CGFloat = 12
    }
    
    struct Spacing{
        static let lg : CGFloat = 48
        static let md : CGFloat = 32
        static let sm : CGFloat = 16
    }
}

public func getEmptyView() -> UIView{
    return UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1000))
}

public func convertStatus (_ status: Int) -> String{
    switch status {
    case K.StatusTask.notStarted:
        return "Not Started"
    case K.StatusTask.preview:
        return "Preview"
    case K.StatusTask.question:
        return "Question"
    case K.StatusTask.read:
        return "Read"
    case K.StatusTask.reflect:
        return "Reflect"
    case K.StatusTask.recite:
        return "Recite"
    default:
        return "Review"
    }
}
