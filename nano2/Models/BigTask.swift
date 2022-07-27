//
//  BigTask.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit

class BigTask{
    var id: String?
    var title: String!
    var tasks: [Task] = []
    var isDone: Bool!
    var dateCompleted: Date!
    var dateCreated: Date!
    
    init(_ title: String, _ tasks: [Task]) {
        self.title = title
        self.tasks = tasks
        self.isDone = false
        self.dateCompleted = Date.now
        self.dateCreated = Date.now
    }
    
    init(id: String, title: String, tasks: [Task], isDone: Bool, dateCompleted: Date?, dateCreated: Date) {
        self.id = id
        self.title = title
        self.tasks = tasks
        self.isDone = isDone
        self.dateCompleted = dateCompleted
        self.dateCreated = dateCreated
    }
    
    func countProgress() -> String{
        var total = 0.0
        self.tasks.forEach { task in
            total += Double(task.status)
        }
        
        let progressText = "\(NSString(format: "%.0f", total/(Double(self.tasks.count)*0.07)) as String) %"
        
        return progressText
    }
}
