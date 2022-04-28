//
//  recipesListViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit
import Kingfisher
import CoreData

final class favouritesListViewController: UIViewController {
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipesListTableView.reloadData()
    }
    
    // MARK: - Var
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    // MARK: - @IBOutlet
    //Table view displaying the list of recipes provided by controller searchViewController
    @IBOutlet weak var recipesListTableView: UITableView!
    
    // MARK: - Functions

    /// Extract the listed food out of an ingredients list (from the JSON)
    /// - Parameter ingredientsList: Affected ingredients
    /// - Returns: Food list as a String
    func ingredientsListToString(ingredientsList: [Ingredient_CD]?) -> String {
        guard let data = ingredientsList else { return "n/a" }
        var inlineList = String()
        for oneIngredient in data {
            inlineList += "\(oneIngredient.name), "
        }
        return inlineList
    }
    
    
    /// Set content in order to be received by next controller as expected (From a Recipe type to a LightRecipeStruct type )
    /// - Parameter selectedRecipe: the recipe to convert
    /// - Returns: the recipe converted
    func prepareContentforSegue(selectedRecipe: Recipe_CD, selectedIngredients: [Ingredient_CD]) -> LightRecipeStruct {
        var detailsSelection = LightRecipeStruct(name: selectedRecipe.name!,
                                                 imageUrl: selectedRecipe.imageUrl!,
                                                 ingredients: [],
                                                 duration: Int(selectedRecipe.duration),
                                                 rate: Int(selectedRecipe.rate),
                                                 uri: selectedRecipe.uri!,
                                                 recipeUrl: selectedRecipe.recipeUrl!)
        
        for oneIngredient in selectedIngredients {
            let data = LightIngedientStruct(name: oneIngredient.name!,
                                            details: oneIngredient.details!)
            detailsSelection.ingredients.append(data)
        }
        return detailsSelection
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension favouritesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let account = coreDataManager?.favouritesList.count else { return 0 }
        return account
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneRecipeCell", for: indexPath) as? oneRecipeTableViewCell else {
            return UITableViewCell()
        }
        //Retreive recipe
        let index = indexPath.row
        let currentRecipe = coreDataManager?.favouritesList[index]
        //Setup cell
        let recipeLabel = currentRecipe?.name
        let recipeDuration = Int(currentRecipe!.duration)
        let likeAccount = Int(currentRecipe!.rate)
        let rearImageUrl = URL(string: (currentRecipe?.imageUrl)!)
        var ingredientsLabel = String()
        ingredientsLabel = ingredientsListToString(ingredientsList: coreDataManager?.getIngredients(for: currentRecipe!))
        cell.configure(for: recipeLabel!, ingredientsLine: ingredientsLabel, rearImage: rearImageUrl!, duration: recipeDuration, yield: likeAccount)
        cell.layer.borderWidth = CGFloat(0.75)
        return cell
    }
}


// MARK: - Extensions - Segue
extension favouritesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromListToFavouriteDetails" {
            let index = recipesListTableView.indexPathForSelectedRow?.row
            let oneRecipeVC = segue.destination as? oneRecipeViewController
            let selectedRecipe = coreDataManager?.favouritesList[index!]
            let ingredientToProvide = coreDataManager?.getIngredients(for: selectedRecipe!)
            let recipeToProvide = prepareContentforSegue(selectedRecipe: selectedRecipe!, selectedIngredients: ingredientToProvide!)
            oneRecipeVC?.recipeDetails = recipeToProvide
        }
    }
}
