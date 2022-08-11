//
//  BigTaskRepository.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 26/07/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

let taskRepo = TaskRepository()

class TaskRepository{
    func fetchBigTasksByRefs(bigTaskRefs: [DocumentReference], completion: @escaping (_ bigTasks: [BigTask]) -> Void){
        var bigTasks : [BigTask] = []
        
        if(bigTaskRefs.isEmpty){
            completion(bigTasks)
        }
        
        let bigGroup = DispatchGroup()
        
        bigTaskRefs.forEach{ ref in
            bigGroup.enter()
            DispatchQueue.main.async {
                
                fs.db.document(ref.path).getDocument{ (docSnapshot, err) in
                    if let err = err {
                        print("Error: \(err.localizedDescription)")
                    }
                    else{
                        if let doc = docSnapshot {
                            
                            // Fetch tasks
                            var tasks : [Task] = []
                            let group = DispatchGroup()
                            group.enter()
                            
                            DispatchQueue.main.async{
                                let taskRefs = doc.get("tasks") as? [DocumentReference] ?? []
                                self.fetchTasksByRef(taskRefs: taskRefs){ fetchedTasks in
                                    tasks = fetchedTasks
                                    group.leave()
                                }
                            }
                            
                            // Create bigTask
                            
                            group.notify(queue: .main){
                                let tsComplete = doc.get("date_completed") as! Timestamp
                                let tsCreated = doc.get("date_created") as! Timestamp
                                
                                bigTasks.append(BigTask(
                                    id: doc.documentID,
                                    title: doc.get("title") as? String ?? "",
                                    tasks: tasks,
                                    isDone: doc.get("is_done") as? Bool ?? false,
                                    dateCompleted: tsComplete.dateValue(),
                                    dateCreated: tsCreated.dateValue()
                                ))
                                bigGroup.leave()
                            }
                        }
                    }
                }
            }
        }
        
        bigGroup.notify(queue: .main){
            completion(bigTasks)
        }
        
    }
    
    func fetchTasksByRef(taskRefs: [DocumentReference], completion: @escaping (_ tasks: [Task]) -> Void){
        var tasks : [Task] = []
        
        if(taskRefs.isEmpty){
            completion(tasks)
        }
        
        let group = DispatchGroup()
        
         taskRefs.forEach{ ref in
             group.enter()
             DispatchQueue.main.async {
                 fs.db.document(ref.path).getDocument{ (docSnapshot, err) in
                     if let err = err {
                         print("Error: \(err.localizedDescription)")
                     }
                     else{
                         if let doc = docSnapshot {
                             
                             tasks.append(Task(
                                 id: doc.documentID,
                                 title: doc.get("title") as? String ?? "",
                                 status: doc.get("status") as? Int ?? 0
                             ))
                             
                             group.leave()
                         }
                     }
                 }
             }
            
        }
        
        group.notify(queue: .main){
            completion(tasks)
        }
    }
    
    func createTask(_ bigTask: BigTask, completion: @escaping () -> Void) {

        // create small tasks
        
        var newTaskPaths : [DocumentReference] = []
        
        let group = DispatchGroup()
        
        bigTask.tasks.forEach{ task in
            group.enter()
            let newTaskRef = fs.rootTask.document()
            newTaskRef.setData([
                "title": task.title!,
                "status": task.status!
            ]) { err in
                if let err = err {
                    print("Error: \(err.localizedDescription)")
                } else {
                    print("Task successfully created")
                    task.id = newTaskRef.documentID
                    newTaskPaths.append(newTaskRef)
                    group.leave()
                }
            }
        }
        
        // create big task
        
        group.notify(queue: .main) {
            let newBigTaskRef = fs.rootBigTask.document()
            newBigTaskRef.setData([
                "title": bigTask.title!,
                "tasks": newTaskPaths,
                "is_done": false,
                "date_completed": FieldValue.serverTimestamp(),
                "date_created": FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    print("Error: \(err.localizedDescription)")
                } else {
                    print("Big Task successfully created")
                    bigTask.id = newBigTaskRef.documentID
                    
                    // append big task to current user
                    currentUser?.ongoingTasks.insert(bigTask, at: 0)
                    fs.rootUsers.document(currentUser!.id).updateData([
                        "big_tasks": FieldValue.arrayUnion([newBigTaskRef])
                    ])
                    completion()
                }
            }
        }
    }
    
    func minProgress(_ task: Task, completion: @escaping (_ success: Bool) -> Void){
        if(task.status > 0){
            task.status -= 1
            fs.rootTask.document(task.id!).updateData([
                "status": task.status!
            ])
            { err in
                if err != nil {
                   print("Error updating task progress")
                    completion(false)
                } else {
                    print("Task progress successfully updated")
                    completion(true)
                }
            }
        }else{
            completion(false)
        }
    }
    
    func addProgress(_ task: Task, completion: @escaping (_ success: Bool) -> Void){
        if(task.status < 7){
            task.status += 1
            fs.rootTask.document(task.id!).updateData([
                "status": task.status!
                ])
            { err in
                if err != nil {
                   print("Error updating task progress")
                    completion(false)
                } else {
                    print("Task progress successfully updated")
                    completion(true)
                }
            }
        }else{
            completion(false)
        }
    }
    
    func setDone(_ bigTask: BigTask){
        fs.rootBigTask.document(bigTask.id!).updateData([
            "is_done": true
        ])
        { err in
            if err != nil {
               print("Error updating task progress")
            } else {
                print("Big Task set to done successfully")
            }
        }
    }
    
    func setNotDone(_ bigTask: BigTask){
        fs.rootBigTask.document(bigTask.id!).updateData([
            "is_done": false
        ])
        { err in
            if err != nil {
               print("Error updating task progress")
            } else {
                print("Big Task set to not done successfully")
            }
        }
    }
    
    func recreateBigTask(_ bigTask: BigTask, completion: @escaping () -> Void){
        //delete exisitng data
        let bigTaskDocRef = fs.rootBigTask.document(bigTask.id!)
        
        let group = DispatchGroup()
        
        //delete big task ref from user
        group.enter()
        fs.rootUsers.document((currentUser?.id)!).updateData([
            "big_tasks" : FieldValue.arrayRemove([bigTaskDocRef])
        ]){ err in
            if err == nil{
                group.leave()
            }
        }
        
        //delete big task
        group.enter()
        fs.rootBigTask.document(bigTask.id!).delete
        { err in
            if err == nil{
                group.leave()
            }
        }
        
        //delete small task
        bigTask.tasks.forEach { task in
            group.enter()
            if(task.id != nil){
                print("title ngentot: \(task.title)")
                fs.rootTask.document(task.id!).delete()
            }
            
            group.leave()
        }
        
        // recreate big task
        group.notify(queue: .main){
            print(bigTask.tasks.last!.title)
            self.createTask(bigTask) {
                let ongoingTasks = currentUser?.ongoingTasks
                print(ongoingTasks!.count-1)
                for idx in 0...ongoingTasks!.count-1{
                    if ongoingTasks![idx] == bigTask{
                        print("\(ongoingTasks![idx].id) == \(bigTask.id)")
                        currentUser?.ongoingTasks.remove(at: idx)
                        break
                    }
                }
                completion()
            }
        }
    }
    
//    func updateJournal(id: String, entry: Entry){
//        fs.rootJournal.document(id).updateData([
//            "title": entry.title,
//            "desc": entry.desc,
//            "mood": entry.mood,
//            "image": entry.image
//        ]) { err in
//            if let err = err {
//                print("Error: \(err.localizedDescription)")
//            } else {
//                print("Journal entry successfully updated")
//            }
//        }
//    }
    
//    func deleteJournal(_ id: String){
//        fs.rootJournal.document(id).delete() { err in
//            if let err = err {
//                print("Error: \(err.localizedDescription)")
//            } else {
//                print("Journal entry successfully removed!")
//            }
//        }
//    }
}

