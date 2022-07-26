//
//  FirestoreHelper.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 10/06/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import FirebaseStorage

let fs = FirestoreHelper()

class FirestoreHelper {
    
    let settings = FirestoreSettings()
    let db = Firestore.firestore()
    var rootUsers: CollectionReference
    var rootBigTask: CollectionReference
    var rootTask: CollectionReference
    
    init(){
        Firestore.firestore().settings = settings
        rootUsers = db.collection("users")
        rootBigTask = db.collection("big_tasks")
        rootTask = db.collection("tasks")
    }

}
