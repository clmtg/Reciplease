//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit

//Controller for the view related of the recipes list provides from the API. (View list of favourite recipes is handled by a different controller)
final class RecipesListViewController: UIViewController {
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipesListInitalPage()
    }
    
    // MARK: - Var
    /// Recipes list and additional details  gathered and provided from the service
    var recipesFullData: RecipeStruct?
    /// Model instance
    let recipeCore = RecipeService()
    /// Recipes list only
    private var recipesList = [Hit]()
    /// recipes list are loaded by 20. Next will store the next page URL if there is more than 20 recipes
    private var nextURL: URL?
    
    // MARK: - @IBOutlet
    //Table view displaying the list of recipes provided by controller SearchViewController
    @IBOutlet weak var recipesListTableView: UITableView!
    @IBOutlet weak var activityIndicatorTableFooter: UIActivityIndicatorView!
    
    // MARK: - Functions
    /// Load the first page of the recipe list received. Does initialise the URL for the next page if needed.
    func loadRecipesListInitalPage(){
        guard let recipesFullData = recipesFullData else {
            displayAnAlert(title: "Oops", message: "Looks like we can't display recipes yet", actions: nil)
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
        recipeCore.loadNextPage(for: url) { [weak self] response in
            guard case .success(let data) = response else { return }
            self?.recipesList.append(contentsOf: data.hits)
            self?.activityIndicatorTableFooter.isHidden = true
            self?.recipesListTableView.reloadData()
            
            guard let urlList = data.links?.next?.href else {
                self?.nextURL = nil
                return
            }
            self?.nextURL = URL(string: urlList)!
        }
    }
    
    /// Set content in order to be received by next controller as expected (From a Recipe type to a LightRecipeStruct type )
    /// - Parameter selectedRecipe: the recipe to convert
    /// - Returns: the recipe converted
    func prepareContentforSegue(selectedRecipe: Recipe) -> LightRecipeStruct {
        var detailsSelection = LightRecipeStruct(name: selectedRecipe.label,
                                                 imageUrl: selectedRecipe.images.large.url,
                                                 ingredients: [],
                                                 duration: selectedRecipe.totalTime,
                                                 rate: selectedRecipe.yield,
                                                 uri: selectedRecipe.shareAs,
                                                 recipeUrl: selectedRecipe.uri)
        
        for oneIngredient in selectedRecipe.ingredients {
            let data = LightIngedientStruct(name: oneIngredient.food,
                                            details: oneIngredient.text)
            detailsSelection.ingredients.append(data)
        }
        return detailsSelection
    }
    
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension RecipesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneRecipeCell", for: indexPath) as? OneRecipeTableViewCell else {
            return UITableViewCell()
        }
        //Retreive recipe
        let index = indexPath.row
        let affectedRecipe = recipesList[index]
        //Setup cell
        let recipeLabel = affectedRecipe.recipe.label
        let ingredientsLine = affectedRecipe.recipe.ingredients.map { $0.food.firstUppercased }.joined(separator: ", ")
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
extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipesList.count-1 {
            guard let nextURL = nextURL else { return }
            activityIndicatorTableFooter.isHidden = false
            loadNextPage(url: nextURL)
        }
    }
    

}

// MARK: - Extensions - Segue
extension RecipesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromListToDetails" {
            let index = recipesListTableView.indexPathForSelectedRow?.row
            let oneRecipeVC = segue.destination as? OneRecipeViewController
            oneRecipeVC?.recipeDetails = prepareContentforSegue(selectedRecipe: recipesList[index!].recipe)
        }
    }
}
