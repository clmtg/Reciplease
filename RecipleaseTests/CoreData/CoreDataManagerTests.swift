//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Clément Garcia on 28/04/2022.
//

import XCTest
@testable import Reciplease

final class CoreDataManagerTests: XCTestCase {
    
    
    // MARK: - Properties
    
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataRepo!
    
    //MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataRepo(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests - Related to adding Recipes
    
    func testGivenRecipeIsCorrect_WhenAddedtoCoreData_ThenEntityIsSaved() {
        coreDataManager.addRecipeToFavourite(FakeDataCoreData.correctLightRecipeWithIngredients) { result in
            guard case .success(let data) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(!coreDataManager.favouritesList.isEmpty)
            XCTAssertTrue(coreDataManager.favouritesList.count == 1)
            XCTAssertTrue(coreDataManager.favouritesList[0].name == "Pizza Swirl Bread")
            XCTAssertTrue(data.name == "Pizza Swirl Bread")
        }
    }
    
    func testGivenRecipeIsCorrupt_WhenAddedtoCoreData_ThenErrorIsThrown() {
        coreDataManager.addRecipeToFavourite(nil) { result in
            guard case .failure(let error) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(coreDataManager.favouritesList.isEmpty)
            XCTAssertTrue(coreDataManager.favouritesList.count == 0)
            XCTAssertTrue(error.description == "Unable to set this recipe as favourite")
        }
    }
    
    // MARK: - Tests - Related to get ingredients for a given recipe
    
    func testGivenRecipeNeedsIngredient_WhenrequestRelatedIngredients_ThenListIsEmpty() {
        var recipeAdded: RecipeCD?
        coreDataManager.addRecipeToFavourite(FakeDataCoreData.correctLightRecipeWithoutIngredients) { result in
            guard case .success(let data) = result else { return }
            recipeAdded = data
        }
        let ingredientsList = coreDataManager.getIngredients(for: recipeAdded!)
        XCTAssertTrue(ingredientsList.isEmpty)
    }
    
    func testGivenRecipeIsFull_WhenrequestRelatedIngredients_ThenListContainsData() {
        var recipeAdded: RecipeCD?
        coreDataManager.addRecipeToFavourite(FakeDataCoreData.correctLightRecipeWithIngredients) { result in
            guard case .success(let data) = result else { return }
            recipeAdded = data
        }
        let ingredientsList = coreDataManager.getIngredients(for: recipeAdded!)
        XCTAssertTrue(!ingredientsList.isEmpty)
        XCTAssertTrue(ingredientsList.count == 2)
    }
    
    // MARK: - Tests - Related to get link recipe and ingredients
    
    func testGivenRecipeNeedsIngredient_WhenAddIngredients_ThenIngredientLightsLink() {
        var recipeAdded: RecipeCD?
        coreDataManager.addRecipeToFavourite(FakeDataCoreData.correctLightRecipeWithoutIngredients) { result in
            guard case .success(let data) = result else { return }
            recipeAdded = data
        }
        let preIngredientsList = coreDataManager.getIngredients(for: recipeAdded!)
        XCTAssertTrue(preIngredientsList.isEmpty)
        coreDataManager.linkIngredients(ingredients: FakeDataCoreData.correctLightIngredientsList, recipe: recipeAdded!)
        let postIngredientsList = coreDataManager.getIngredients(for: recipeAdded!)
        XCTAssertTrue(!postIngredientsList.isEmpty)
        XCTAssertTrue(postIngredientsList.count == 2)
    }
    
    // MARK: - Tests - Related to removing recipe from local storage
    
    func testGivenRecipeNeedsToBeRemoved_WhenRequestDrop_ThenRecipeIsDelete() {
        var recipeAdded: RecipeCD?
        coreDataManager.addRecipeToFavourite(FakeDataCoreData.correctLightRecipeWithoutIngredients) { result in
            guard case .success(let data) = result else { return }
            recipeAdded = data
        }
        XCTAssertTrue(coreDataManager.favouritesList.contains(recipeAdded!))
        coreDataManager.dropRecipe(for: (recipeAdded?.uri)!)
        XCTAssertTrue(!coreDataManager.favouritesList.contains(recipeAdded!))
    }
}
