//
//  Task.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit

class Task : Equatable {
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
    
    var id: String?
    var title: String!
    var status: Int!
    
    init(_ title: String, _ status: Int){
        self.title = title
        self.status = status
    }
    
    init(id: String, title: String, status: Int){
        self.id = id
        self.title = title
        self.status = status
    }
}
