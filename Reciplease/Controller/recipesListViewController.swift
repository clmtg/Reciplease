//
//  recipesListViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit

final class recipesListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipesListInitalPage()
    }
    
    // MARK: - Var
    /// Recipes list and additional details  gathered and provided from the service
    var recipesFullData: RecipeStruct?
    /// Model instance
    let recipeCore = recipeService()
    /// Recipes list only
    private var recipesList = [Hit]()
    /// recipes list are loaded by 20. Next will store the next page URL if there is more than 20 recipes
    private var nextURL: URL?
    
    // MARK: - @IBOutlet
    //Table view displaying the list of recipes provided by controller searchViewController
    @IBOutlet weak var recipesListTableView: UITableView!
    
    // MARK: - Functions
    /// Extract the listed food out of an ingredients list (from the JSON)
    /// - Parameter ingredientsList: Affected ingredients
    /// - Returns: Food list as a String
    func ingredientsListToString(ingredientsList: [Ingredient]) -> String {
        var finalStr = String()
        for item in ingredientsList {
            finalStr += "\(item.food.firstUppercased), "
        }
        return finalStr
    }
    
    /// Load the first page of the recipe list received. Does initialise the URL for the next pahe if needed.
    func loadRecipesListInitalPage(){
        guard let recipesFullData = recipesFullData, recipesFullData.count > 0 else {
            displayAnAlert(title: "Oops", message: "Looks like we can't display a list with this ingredients list", actions: nil)
            return
        }
        recipesList = recipesFullData.hits
        
        if let urlList = recipesFullData.links?.next?.href {
            nextURL = URL(string: urlList)!
        }
    }

    /// Load more recipes using the next page link
    /// - Parameter url: Link of the next page to load
    func loadNextPage(url: URL) {
        recipeCore.loadNextPage(for: url) { response in
            guard case .success(let data) = response else { return }
            
            for hit in data.hits {
                self.recipesList.append(hit)
            }
            
            if let urlList = data.links?.next?.href {
                self.nextURL = URL(string: urlList)!
            }
            else {
                self.nextURL = nil
            }
            self.recipesListTableView.reloadData()
        }
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension recipesListViewController: UITableViewDataSource {
    
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
        let recipeLabel = affectedRecipe.recipe.label
        let ingredientsLine = ingredientsListToString(ingredientsList: affectedRecipe.recipe.ingredients)
        let recipeDuration = affectedRecipe.recipe.totalTime
        let likeAccount = affectedRecipe.recipe.yield
        let rearImageUrl = URL(string: affectedRecipe.recipe.images.large.url)!
        cell.configure(for: recipeLabel,
                       ingredientsLine: ingredientsLine,
                       rearImage: rearImageUrl,
                       duration: recipeDuration,
                       yield: likeAccount)
        
        cell.layer.borderWidth = CGFloat(0.75)
        return cell
    }
}

//To conform at UITableViewDelegate protocol.
extension recipesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipesList.count-1 {
            guard nextURL != nil else { return }
            loadNextPage(url: nextURL!)
        }
    }
}

// MARK: - Extensions - Segue
extension recipesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "segueFromListToDetails" {
           let index = recipesListTableView.indexPathForSelectedRow?.row
           let oneRecipeVC = segue.destination as? oneRecipeViewController
           oneRecipeVC?.recipeDetails = recipesList[index!]
       }
    }
}
