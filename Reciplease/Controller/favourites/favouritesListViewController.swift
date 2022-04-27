//
//  recipesListViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit
import Kingfisher

final class favouritesListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipesListTableView.reloadData()
    }
    
    // MARK: - Var
    /// CoreData instance
    let repo = CoreDataRepo()
    
    /// List of favourite recipes from CoreData
    private var recipesList: [Recipe_CD] {
        var data: [Recipe_CD]?
        repo.getFavourites { result in
            guard case .success(let recipeList) = result else {
                data = nil
                return
            }
            data = recipeList
        }
        return data!
    }
    
    // MARK: - @IBOutlet
    //Table view displaying the list of recipes provided by controller searchViewController
    @IBOutlet weak var recipesListTableView: UITableView!
    
    // MARK: - Functions
    /// Extract the listed food out of an ingredients list (from the JSON) <============== Could be used with genereics ?!
    /// - Parameter ingredientsList: Affected ingredients
    /// - Returns: Food list as a String
    func ingredientsListToString(ingredientsList: [Ingredient_CD]?) -> String {
        
        guard let ingredientsList = ingredientsList else { return String() }
        
        var finalStr = String()
        for item in ingredientsList {
            finalStr += "\(item.name?.firstUppercased), "
        }
        return finalStr
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension favouritesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneRecipeCell", for: indexPath) as? oneRecipeTableViewCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let affectedRecipe = recipesList[index]
        let recipeLabel = affectedRecipe.name
        //let ingredientsLine = ingredientsListToString(ingredientsList: affectedRecipe.ingredients)
        let recipeDuration = affectedRecipe.duration
        let likeAccount = affectedRecipe.rate
        let rearImageUrl = URL(string: affectedRecipe.artworkUrl!)!
        cell.configure(for: recipeLabel!,
                       ingredientsLine: "",
                       rearImage: rearImageUrl,
                       duration: Int(recipeDuration),
                       yield: Int(likeAccount))
        
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
           //oneRecipeVC?.recipeDetails = recipesList[index!]
       }
    }
}
