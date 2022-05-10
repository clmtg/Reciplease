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
    var favouritesList: [RecipeCD] {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
    //MARK: - Functions - EDIT (Add/Edit/Remove)
    /// Add a favourite and the related ingredients to CoreData model
    /// - Parameters:
    ///   - recipe: recipe to add
    ///   - completionHandler: steps to process once done
    func addRecipeToFavourite(_ recipe: LightRecipeStruct?, completionHandler: (Result<RecipeCD, ServiceError>) -> Void) {
        guard let recipe = recipe else {
            completionHandler(.failure(.failureToEditLocal))
            return
        }
        
        let recipeToSave = RecipeCD(context: managedObjectContext)
        recipeToSave.duration = Int16(recipe.duration)
        recipeToSave.imageUrl = recipe.imageUrl
        recipeToSave.name = recipe.name
        recipeToSave.rate = Int16(recipe.rate)
        recipeToSave.recipeUrl = recipe.recipeUrl
        recipeToSave.uri =  recipe.uri
        coreDataStack.saveContext()
        
        if !recipe.ingredients.isEmpty {
            linkIngredients(ingredients: recipe.ingredients, recipe: recipeToSave)
        }
        completionHandler(.success(recipeToSave))
    }

    /// Add ingredients, for a given recipe, to CoreData model
    /// - Parameters:
    ///   - ingredients: list of ingredients to add
    ///   - recipe: related recipe
    ///   - completionHandler: steps to process once done
    func linkIngredients(ingredients: [LightIngedientStruct], recipe: RecipeCD) {
        var ingredientsToSave = [IngredientCD]()
        for oneIngredient in ingredients {
            let data = IngredientCD(context: managedObjectContext)
            data.name = oneIngredient.name
            data.details = oneIngredient.details
            data.recipe = recipe
            ingredientsToSave.append(data)
        }
        coreDataStack.saveContext()
    }
    
    /// Delete a recipe entity from CoreData using the recipe URI
    /// - Parameter uri: uri of the affected recipe
    func dropRecipe(for uri: String) {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        let recipeFilter = NSPredicate(format: "uri == %@", uri)
        request.predicate = recipeFilter
        guard let data = try? coreDataStack.mainContext.fetch(request) else { return }
        data.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
    //MARK: - Functions - GET Retreive data
    
    /// Provide the list of ingredients for a given recipethrough a closure
    /// - Parameter completionHandler: closure to process
    func getIngredients(for recipe: RecipeCD) -> [IngredientCD] {
        let request: NSFetchRequest<IngredientCD> = IngredientCD.fetchRequest()
        let recipeFilter = NSPredicate(format: "recipe == %@", recipe)
        request.predicate = recipeFilter
        guard let data = try? coreDataStack.mainContext.fetch(request) else {
            return [IngredientCD]()
        }        
        return data
    }
}
