//
//  UserRepository.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 26/07/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

let userRepo = UserRepository()

class UserRepository{
    
    func fetchUser(completion: @escaping () -> Void){
        fs.rootUsers.document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, err) in
            if let doc = docSnapshot {
                // Fetch big tasks, fetch friends at friends page to reduce load
                var bigTasks : [BigTask] = []
                let group = DispatchGroup()
                group.enter()
                
                DispatchQueue.main.async{
                    let bigTaskRefs = doc.get("big_tasks") as? [DocumentReference] ?? []
                    taskRepo.fetchBigTasksByRefs(bigTaskRefs: bigTaskRefs){ fetchedBigTasks in
                        bigTasks = fetchedBigTasks
                        group.leave()
                    }
                }
                
                // Set current user data
                group.notify(queue: .main){
                    var ongoingTasks : [BigTask] = []
                    var finishedTasks : [BigTask] = []
                    
                    bigTasks.forEach { bigTask in
                        bigTask.isDone ? finishedTasks.append(bigTask) : ongoingTasks.append(bigTask)
                    }
                    
                    currentUser = User(
                        id: Auth.auth().currentUser!.uid,
                        email: doc.get("email") as? String ?? "",
                        username: doc.get("username") as? String ?? "",
                        xp: doc.get("xp") as? Int ?? 0,
                        ongoingTasks: ongoingTasks,
                        finishedTasks: finishedTasks,
                        friends: []
                    )
                    
                    currentUser?.ongoingTasks.sort { (lhs: BigTask, rhs: BigTask) -> Bool in
                        return lhs.dateCreated > rhs.dateCreated
                    }
                    
                    completion()
                }
            }

            else {
                print("Error: \(err!.localizedDescription)")
            }
        }
    }
                    
}
