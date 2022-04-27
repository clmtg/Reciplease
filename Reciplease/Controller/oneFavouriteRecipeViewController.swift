//
//  oneRecipeViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 22/04/2022.
//

import UIKit
import Kingfisher

class oneFavouriteRecipeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }
    
    // MARK: - Vars
    //Details related to the affected recipe received from other controller
    var recipeDetails: Recipe_CD?
    //Computed property to gather recipe image URL
    var recipeImageUrl: String? {
        return recipeDetails?.artworkUrl
    }
    //Ingredients list for the affected recipe (data source for table view)
    var ingredientsList = [String]()

    
    // MARK: - IBOutlet
    //Label displaying the recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    //UIImageView displaying the image recipe
    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - IBAction
    @IBAction func tappedFavouriteButton(_ sender: Any) {
        
        let repo = CoreDataRepo()
        //repo.remove
        
    }
    
    
    // MARK: - Function
    /// Load the recipe details into the related label, tableview, etc...
    func loadDetails() {
        guard let details = recipeDetails else { return }
        recipeNameLabel.text = details.name?.firstUppercased
        recipeImageView.kf.setImage(with: URL(string: recipeImageUrl!)!)

/*
        
        for oneIngredient in recipeDetails!.ingredients
 
 ===> does not conform to sequence 
  
 */
        
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension oneFavouriteRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneIngredientCell", for: indexPath)
        cell.textLabel!.text = ingredientsList[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
}
