//
//  User.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 26/07/22.
//

import Foundation
import UIKit

class User{
    var id: String!
    var email: String!
    var username: String!
    var xp: Int!
    var ongoingTasks: [BigTask]!
    var finishedTasks: [BigTask]!
    var friends: [User]!
    
    init(id: String, email: String, username: String, xp: Int, ongoingTasks: [BigTask], finishedTasks: [BigTask], friends: [User]) {
        self.id = id
        self.email = email
        self.username = username
        self.xp = xp
        self.ongoingTasks = ongoingTasks
        self.finishedTasks = finishedTasks
        self.friends = friends
    }
}
