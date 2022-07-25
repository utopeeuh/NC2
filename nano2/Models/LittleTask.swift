//
//  LittleTask.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit

class LittleTask {
    var title: String!
    var goals: String!
    var status: String!
    
    init(_ title: String, _ goals: String, _ status: String){
        self.title = title
        self.goals = goals
        self.status = status
    }
}
