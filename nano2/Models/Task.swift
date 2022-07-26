//
//  Task.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit

class Task {
    var id: String?
    var title: String!
    var goals: String!
    var status: Int!
    
    init(_ title: String, _ goals: String){
        self.title = title
        self.goals = goals
        self.status = K.StatusTask.notStarted
    }
    
    init(id: String, title: String, goals: String, status: Int){
        self.id = id
        self.title = title
        self.goals = goals
        self.status = status
    }
}
