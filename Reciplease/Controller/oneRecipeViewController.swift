//
//  oneRecipeViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 22/04/2022.
//

import UIKit
import Kingfisher
import CoreData

class oneRecipeViewController: UIViewController {
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
        loadDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toggleFavouriteButton(next: isFavourite)
    }
    
    // MARK: - Vars
    /// Details related to the affected recipe received from other controller
    var recipeDetails: LightRecipeStruct?
    /// List of ingredient related to the affected recipe
    var ingredientsList: [LightIngedientStruct] {
        guard let recipeDetails = recipeDetails else { return [] }
        return recipeDetails.ingredients
    }
    /// Is recipy currently display part of the favourite list
    var isFavourite: Bool {
        guard let favourite = coreDataManager?.favouritesList else { return false }
        return favourite.contains { localRecipe in
            guard localRecipe.uri == recipeDetails?.uri else { return false }
            return true
        }
    }
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    // MARK: - IBOutlet
    /// UIImageView displaying the image recipe
    @IBOutlet weak var recipeImageView: UIImageView!
    /// Label displaying the recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    /// UIBarButtonItem used to add/remove recipe from favourite list
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    // MARK: - IBActions
    /// Performed when UIButton "Get directions" has been tapped
    @IBAction func didTappedGetDirections(_ sender: Any) {
        guard let url = recipeDetails?.uri else { return }
        UIApplication.shared.open(URL(string: url)!)
    }
    /// Performed when UIButton "favouriteButton" has been tapped
    @IBAction func tappedFavouriteButton(_ sender: Any) {
        updateStatus(next: !isFavourite)
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
        toggleFavouriteButton(next: isFavourite)
    }
    
    /// Add or remove current recipe from favourites list using CoreData. Does update the NavBarButton too
    /// - Parameter status: Once performed, will the recipe be part of favourites
    private func updateStatus(next status: Bool) {
        if status {
            coreDataManager?.addRecipeToFavourite(recipeDetails, completionHandler: { result in
                guard case .success(_) = result else {
                    displayAnAlert(title: "Error", message: "Unable to store this recipe yet. Please try again later", actions: nil)
                    return
                }
                toggleFavouriteButton(next: status)
            })
        }
        else {
            coreDataManager?.dropRecipe(for: recipeDetails!.uri)
            toggleFavouriteButton(next: status)
            let i = navigationController?.viewControllers.firstIndex(of: self)
            let previousViewController = navigationController?.viewControllers[i!-1]
            guard let vcTitle = previousViewController?.title, vcTitle == "FavouritesList" else { return }
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// Update UIBarButtonItem according recipe status
    /// - Parameter status: Once performed, should the button match the "favourite status"
    func toggleFavouriteButton(next status: Bool) {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .large)
        var systemIcon = String()
        if status { systemIcon = "star.fill" } else { systemIcon = "star" }
        favouriteButton.image = UIImage(systemName: systemIcon, withConfiguration: imageConfiguration)
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


