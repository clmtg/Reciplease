//
//  CoreDataRepo.swift
//  Reciplease
//
//  Created by Clément Garcia on 26/04/2022.
//

import Foundation
import CoreData

/// Class handling the data (get/save/delete/etc...) through the CoreDataStack
final class CoreDataRepo {
    
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    // MARK: - Initializer
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    // MARK: - Computed var
    var favouritesList: [Recipe_CD] {
        let request: NSFetchRequest<Recipe_CD> = Recipe_CD.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
    
    //MARK: - Functions - EDIT (Add/Edit/Remove)

    
    /// Add a favourite and the related ingredients to CoreData model
    /// - Parameters:
    ///   - recipe: recipe to add
    ///   - completionHandler: steps to process once done
    func addRecipeToFavourite(_ recipe: LightRecipeStruct?, completionHandler: (ServiceError?) -> Void) {
        guard let recipe = recipe else {
            completionHandler(.failureToEditLocal)
            return
        }
        
        let recipeToSave = Recipe_CD(context: managedObjectContext)
        
        recipeToSave.duration = Int16(recipe.duration)
        recipeToSave.imageUrl = recipe.imageUrl
        recipeToSave.name = recipe.name
        recipeToSave.rate = Int16(recipe.rate)
        recipeToSave.recipeUrl = recipe.recipeUrl
        recipeToSave.uri =  recipe.uri
        coreDataStack.saveContext()
        
        linkIngredients(ingredients: recipe.ingredients, recipe: recipeToSave, completionHandler: completionHandler)
    }

    
    /// Add ingredients, for a given recipe, to CoreData model
    /// - Parameters:
    ///   - ingredients: list of ingredients to add
    ///   - recipe: related recipe
    ///   - completionHandler: steps to process once done
    func linkIngredients(ingredients: [LightIngedientStruct], recipe: Recipe_CD, completionHandler: (ServiceError?) -> Void) {
        var ingredientsToSave = [Ingredient_CD]()
        
        for oneIngredient in ingredients {
            let data = Ingredient_CD(context: managedObjectContext)
            data.name = oneIngredient.name
            data.details = oneIngredient.details
            data.recipe = recipe
            ingredientsToSave.append(data)
        }
        coreDataStack.saveContext()
    }
    
    func dropRecipe(for uri: String) {
        let request: NSFetchRequest<Recipe_CD> = Recipe_CD.fetchRequest()
        let recipeFilter = NSPredicate(format: "uri == %@", uri)
        request.predicate = recipeFilter
        guard let data = try? coreDataStack.mainContext.fetch(request) else { return }
        data.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
  
    
    //MARK: - Functions - GET Retreive data
    
    /// Provide the list of ingredients for a given recipethrough a closure
    /// - Parameter completionHandler: closure to process
    func getIngredients(for recipe: Recipe_CD) -> [Ingredient_CD] {
        let request: NSFetchRequest<Ingredient_CD> = Ingredient_CD.fetchRequest()
        let recipeFilter = NSPredicate(format: "recipe == %@", recipe)
        request.predicate = recipeFilter
        guard let data = try? coreDataStack.mainContext.fetch(request) else {
            return [Ingredient_CD]()
        }        
        return data
    }
    
    
}
