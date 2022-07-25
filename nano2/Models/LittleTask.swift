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
    var status: Int!
    
    init(_ title: String, _ goals: String){
        self.title = title
        self.goals = goals
        self.status = K.StatusTask.notStarted
    }
}
