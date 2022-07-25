//
//  BigTask.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit

class BigTask{
    var title: String!
    var littleTasks: [LittleTask] = []
    
    init(_ title: String, _ littleTasks: [LittleTask]) {
        self.title = title
        self.littleTasks = littleTasks
    }
}
