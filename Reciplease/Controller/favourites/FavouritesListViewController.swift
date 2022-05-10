//
//  FavouritesListViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit
import Kingfisher
import CoreData
import Foundation

//Controller for the view related of the favourite recipes list. (View list of recipes list provided by the API is handled by a different controller)
final class FavouritesListViewController: UIViewController {
    
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
    //Table view displaying the list of recipes provided by controller SearchViewController
    @IBOutlet weak var recipesListTableView: UITableView!
    
    // MARK: - Functions
    /// Extract the listed food out of an ingredients list (from the JSON)
    /// - Parameter ingredientsList: Affected ingredients
    /// - Returns: Food list as a String
    func ingredientsListToString(ingredientsList: [IngredientCD]?) -> String {
        guard let data = ingredientsList else { return "n/a" }
        var inlineList = String()
        for oneIngredient in data {
            inlineList += "\(oneIngredient.name ?? "Mystery ingredient"), "
        }
        return inlineList
    }
    
    /// Set content in order to be received by next controller as expected (From a Recipe coredata model type to a LightRecipeStruct type )
    /// - Parameter selectedRecipe: the recipe to convert
    /// - Returns: the recipe converted
    func prepareContentforSegue(selectedRecipe: RecipeCD, selectedIngredients: [IngredientCD]) -> LightRecipeStruct? {
        guard let name = selectedRecipe.name,
              let imageUrl = selectedRecipe.imageUrl,
              let uri = selectedRecipe.uri,
              let recipeUrl = selectedRecipe.recipeUrl else { return nil }
        
        var detailsSelection = LightRecipeStruct(name: name,
                                                 imageUrl: imageUrl,
                                                 ingredients: [],
                                                 duration: Int(selectedRecipe.duration),
                                                 rate: Int(selectedRecipe.rate),
                                                 uri: uri,
                                                 recipeUrl: recipeUrl)
        
        for oneIngredient in selectedIngredients {
            if let name = oneIngredient.name, let details = oneIngredient.details {
                let data = LightIngedientStruct(name: name, details: details)
                detailsSelection.ingredients.append(data)
            }
        }
        return detailsSelection
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension FavouritesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let account = coreDataManager?.favouritesList.count else { return 0 }
        return account
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneRecipeCell", for: indexPath) as? OneRecipeTableViewCell else {
            return UITableViewCell()
        }
        //Retreive recipe
        let index = indexPath.row
        guard let currentRecipe = coreDataManager?.favouritesList[index] else { return cell }
        //Setup cell
        let recipeLabel = currentRecipe.name ?? "Name unavailable"
        let recipeDuration = Int(currentRecipe.duration)
        let likeAccount = Int(currentRecipe.rate)
        let rearImageUrl = URL(string: (currentRecipe.imageUrl ?? "https://source.unsplash.com/random/?food"))!
        var ingredientsLabel = String()
        ingredientsLabel = ingredientsListToString(ingredientsList: coreDataManager?.getIngredients(for: currentRecipe))
        cell.configure(for: recipeLabel, ingredientsLine: ingredientsLabel, rearImage: rearImageUrl, duration: recipeDuration, yield: likeAccount)
        cell.layer.borderWidth = CGFloat(0.75)
        return cell
    }
}

//To conform at UITableViewDelegate protocol.
extension FavouritesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let uri = coreDataManager?.favouritesList[indexPath.row].uri else { return }
            coreDataManager?.dropRecipe(for: uri)
            recipesListTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "To add favourites,\ntap on the star within a recipe."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.favouritesList.isEmpty ?? true ? 400 : 0
    }
}

// MARK: - Extensions - Segue
extension FavouritesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromListToFavouriteDetails" {
            let index = recipesListTableView.indexPathForSelectedRow?.row
            let oneRecipeVC = segue.destination as? OneRecipeViewController
            guard let selectedRecipe = coreDataManager?.favouritesList[index!] else { return }
            let ingredientToProvide = coreDataManager?.getIngredients(for: selectedRecipe)
            let recipeToProvide = prepareContentforSegue(selectedRecipe: selectedRecipe, selectedIngredients: ingredientToProvide ?? [])
            oneRecipeVC?.recipeDetails = recipeToProvide
        }
    }
}
