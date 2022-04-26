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
    var recipeDetails: Hit?
    //Computed property to gather recipe image URL
    var recipeImageUrl: String? {
        return recipeDetails?.recipe.images.large.url
    }
    //Ingredients list for the affected recipe (data source for table view)
    var ingredientsList = [String]()
    
    // MARK: - IBOutlet
    //Label displaying the recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    //UIImageView displaying the image recipe
    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - Function
    /// Load the recipe details into the related label, tableview, etc...
    func loadDetails() {
        guard let details = recipeDetails?.recipe else { return }
        //navigationItem.title = details.label
        recipeNameLabel.text = details.label.firstUppercased
        recipeImageView.kf.setImage(with: URL(string: recipeImageUrl!)!)
        
        for item in details.ingredients {
            ingredientsList.append("- \(item.text)")
        }
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension oneRecipeViewController: UITableViewDataSource {
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
