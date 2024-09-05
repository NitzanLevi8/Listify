//
//  ListifyApp.swift
//  Listify
//
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabaseInternal
import FirebaseFirestore

extension Array {
    func find(run: (_ value: Element)-> Bool)-> Element?{
        let index = self.firstIndex { return run($0) }
        if (index != nil){
            return self[index!] as Element
        }
        return nil
    }
}

extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

import SwiftUI

@main
struct ListifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var model: AppModel = AppModel()
    
    var body: some Scene {
        WindowGroup {
            MainPage(list: $model.lists).task {
                await model.getAllLists()
            }
        }.environmentObject(model)
    }
}
