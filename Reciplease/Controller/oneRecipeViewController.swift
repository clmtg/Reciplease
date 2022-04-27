//
//  oneRecipeViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 22/04/2022.
//

import UIKit
import Kingfisher

class oneRecipeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }
    
    // MARK: - Vars
    //Details related to the affected recipe received from other controller
    var recipeDetails: Recipe_CD?
    var ingredientsList: [Ingredient_CD]?
    
    //CoreData instance
    let repo = CoreDataRepo()
    
    // MARK: - IBOutlet
    //Label displaying the recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    //UIImageView displaying the image recipe
    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - Function
    /// Load the recipe details into the related label, tableview, etc...
    func loadDetails() {
        guard let details = recipeDetails else { return }
        recipeNameLabel.text = details.name
        recipeImageView.kf.setImage(with: URL(string: details.artworkUrl ?? "https://source.unsplash.com/random"))
        
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension oneRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneIngredientCell", for: indexPath)
        cell.textLabel!.text = ingredientsList![indexPath.row].details
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredientsList = ingredientsList else {return 0}
        return ingredientsList.count
    }
}
