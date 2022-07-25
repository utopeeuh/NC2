//
//  Constants.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 24/07/22.
//

import Foundation
import UIKit
import SnapKit

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
    }
}

func convertStatus (_ status: Int) -> String{
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
