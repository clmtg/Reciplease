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
    /// Details related to the affected recipe received from other controller
    var recipeDetails: LightRecipeStruct?
    /// List of ingredient related to the affected recipe
    var ingredientsList: [LightIngedientStruct] {
        guard let recipeDetails = recipeDetails else { return [] }
        return recipeDetails.ingredients
    }
    
    // MARK: - IBOutlet
    /// UIImageView displaying the image recipe
    @IBOutlet weak var recipeImageView: UIImageView!
    /// Label displaying the recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    // MARK: - IBActions
    /// Performed when UIButton "Get directions" has been tapped
    @IBAction func didTappedGetDirections(_ sender: Any) {
        guard let url = recipeDetails?.uri else { return }
        UIApplication.shared.open(URL(string: url)!)
    }
    
    // MARK: - Functions
    /// Load the recipe details into the related label, tableview, etc...
    private func loadDetails() {
        guard let details = recipeDetails else {
            displayAnAlert(title: "Loading error", message: "Failed to load data for the recipe selected", actions: nil)
            return
        }
        recipeNameLabel.text = details.name
        recipeImageView.kf.setImage(with: URL(string: details.imageUrl))
    }
}

// MARK: - Extensions - TableView - DataSource & Delelegate
//To conform at UITableViewDataSource protocol.
extension oneRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneIngredientCell", for: indexPath)
        cell.textLabel!.text = "- \(ingredientsList[indexPath.row].details)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
}


