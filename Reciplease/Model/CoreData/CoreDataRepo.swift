//
//  CoreDataRepo.swift
//  Reciplease
//
//  Created by Clément Garcia on 26/04/2022.
//

import Foundation
import CoreData

/// Class handling the data (get/save) through the CoreDataStack
final class CoreDataRepo {
    
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Vars
    /// CoreDataStack
    private let coreDataStack: CoreDataStack
    
    //MARK: - Functions - EDIT (Add/Edit/Remove)
    
    /// Save a recipe as favourite to be loaded locally if needed
    /// - Parameters:
    ///   - recipe: recipe to add
    ///   - completionHandler: steps to process based on success result
    func addRecipeToFavourite(_ recipe: Recipe?, completionHandler: (ServiceError?) -> Void) {
        guard let recipe = recipe else {
            completionHandler(.failureToEditLocal)
            return
        }
        
        let recipeToSave = Recipe_CD(context: coreDataStack.viewContext)
        //let recipeToSave = Recipe_
        recipeToSave.artworkUrl = recipe.images.large.url
        recipeToSave.directUrl = recipe.uri
        recipeToSave.duration = Int16(recipe.totalTime)
        recipeToSave.name = recipe.label
        recipeToSave.rate = Int16(recipe.yield)
        
        do {
            try coreDataStack.viewContext.save()
            linkIngredients(ingredients: recipe.ingredients, recipe: recipeToSave, completionHandler: completionHandler)
        }
        catch {
            completionHandler(.failureToEditLocal)
        }
        
    }
    
    /// Add ingredients within CoreData model and link them to the affected recipe
    /// - Parameters:
    ///   - ingredients: array of ingredients to add
    ///   - recipe: affected recipe
    ///   - completionHandler: steps to perform once done
    func linkIngredients(ingredients: [Ingredient], recipe: Recipe_CD, completionHandler: (ServiceError?) -> Void) {
        var ingredientsToSave = [Ingredient_CD]()
        for oneIngredient in ingredients {
            let data = Ingredient_CD(context: coreDataStack.viewContext)
            data.name = oneIngredient.food
            data.details = oneIngredient.text
            data.recipe = recipe
            ingredientsToSave.append(data)
        }
        
        do {
            try coreDataStack.viewContext.save()
            completionHandler(nil)
        }
        catch {
            completionHandler(.failureToEditLocal)
        }
    }
    
    /// Remove the affected recipe for the favourites list (local)
    /// - Parameter recipe: recipe to remove
    func dropRecipe(recipe: Recipe_CD) {
        coreDataStack.viewContext.delete(recipe)
    }
    
    //MARK: - Functions - GET Retreive data
    
    /// Provide the list of favourite recipe through a closure
    /// - Parameter completionHandler: closure to process
    func getFavourites(completionHandler: (Result<[Recipe_CD], ServiceError>) -> Void ) {
        let request: NSFetchRequest<Recipe_CD> = Recipe_CD.fetchRequest()
        guard let data = try? coreDataStack.viewContext.fetch(request) else {
            completionHandler(.failure(.failureOnlocalLoading))
            return
        }
        completionHandler(.success(data))
    }
    
    /// Provide the list of ingredients for a specific through a closure
    /// - Parameter completionHandler: closure to process
    func getIngredients(for recipe: Recipe_CD,completionHandler: (Result<[Ingredient_CD], ServiceError>) -> Void ) {
        let request: NSFetchRequest<Ingredient_CD> = Ingredient_CD.fetchRequest()
        let recipeFilter = NSPredicate(format: "recipe == %@", recipe)
        request.predicate = recipeFilter
        
        guard let data = try? coreDataStack.viewContext.fetch(request) else {
            completionHandler(.failure(.failureOnlocalLoading))
            return
        }        
        completionHandler(.success(data))
    }
    
    
}

