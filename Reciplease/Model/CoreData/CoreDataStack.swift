//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Clément Garcia on 26/04/2022.
//

import Foundation
import CoreData

final class CoreDataStack {
    
 
    
    //MARK: - Singleton implementation
    static let sharedInstance = CoreDataStack()
    
    //MARK: - Vars
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Fail to load favourite")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
       return CoreDataStack.sharedInstance.persistentContainer.viewContext
     }
}
