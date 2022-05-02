//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButtonState(buttons: [addButton], isEnable: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ingredientsList.count > 0 ? toggleButtonState(buttons: [searchButton], isEnable: true) : toggleButtonState(buttons: [searchButton], isEnable: false)
    }
    
    // MARK: - Var
    /// ingredientsList to perform manual test
    // ============================ Une service qui gere ajout, suppression, stockage (Dans le coreData (car il y a deja linkIngredient) ? Juste dans le model ?)???
    private var ingredientsList = ["Bread", "Tomato"] {
        didSet {
            ingredientsList.isEmpty ? toggleButtonState(buttons: [clearButton,searchButton], isEnable: false) : toggleButtonState(buttons: [clearButton,searchButton], isEnable: true)
        }
    }
    /// Model instance
    let recipeCore = RecipeService()
    /// List of recipes gathered and provided from the service
    private var recipesList: RecipeStruct?
    /// The user input with the unnecessary characters removed (whitespace, newline...)
    private var userInputFiltered: String {
        guard let input = ingredientsInputTextField.text else { return String() }
        return input.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased
    }
    
    // MARK: - @IBOutlet
    /// Textfield input for the user to add an ingredient
    @IBOutlet weak var ingredientsInputTextField: UITextField!
    /// UIButon to add ingredient input from user
    @IBOutlet weak var addButton: UIButton!
    /// UIButon to clear the list of ingredient
    @IBOutlet weak var clearButton: UIButton!
    /// UIButon to process recipes search
    @IBOutlet weak var searchButton: UIButton!
    /// TableView displaying the list of ingtredients input by user
    @IBOutlet weak var ingredientsListTableView: UITableView!
    
    // MARK: - @IBAction
    @IBAction func tappedAddButton(_ sender: Any) {
        addIngredientInput()
    }
    
    @IBAction func tappedClearButton(_ sender: Any) {
        ingredientsList.removeAll()
        ingredientsListTableView.reloadData()
    }
    
    @IBAction func tappedSearchButton(_ sender: Any) {
        toggleButtonState(buttons: [searchButton], isEnable: false)
        searchRecipes()
    }
    
    @IBAction func tapGestureOnDisplay(_ sender: Any) {
        dismissKeyboard(firstResponder: ingredientsInputTextField)
    }
    
    // MARK: - View functions
    
    /// Retreive the ingredient name from user input and add it to the ingredient list
    private func addIngredientInput() {
        guard userInputFiltered.isEmpty != true else {
            displayAnAlert(title: "Ingredient missing", message: "Please type an ingredient name first.", actions: nil)
            return
        }
        
        guard ingredientsList.contains(userInputFiltered) == false else {
            displayAnAlert(title: "Ingredient listed already", message: "'\(userInputFiltered)' is already within your ingredients list.", actions: nil)
            return
        }
        
        ingredientsList.append(userInputFiltered)
        ingredientsInputTextField.text = String()
        toggleButtonState(buttons: [addButton], isEnable: false)
        ingredientsListTableView.reloadData()
    }
    
    // MARK: - Model communication functions
    
    /// Use the model to retreive a recipes lit and store them within recipesList var.
    func searchRecipes() {
        recipeCore.searchRecipes(with: ingredientsList) { result in
            switch result {
            case .failure(let error):
                self.displayAnAlert(title: "Error", message: error.localizedDescription, actions: nil)
            
            case .success(let data):
                self.recipesList = data
                
                guard data.count > 0 else {
                    self.displayAnAlert(title: "No recipe found", message: "Looks like we can't display recipes with this ingredients list", actions: nil)
                    return
                }

                self.performSegue(withIdentifier: "segueFromSearchToResult", sender: self.recipesList)
            }
        }
    }
}


// MARK: - Extensions - UITextField
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        toggleButtonState(buttons: [addButton], isEnable: false)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredientInput()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nextTextFieldContent = (ingredientsInputTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if nextTextFieldContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            toggleButtonState(buttons: [addButton], isEnable: false)
        } else {
            toggleButtonState(buttons: [addButton], isEnable: true)
        }
        return true
    }
    
}

// MARK: - Extensions - TableView
//To conform at UITableViewDataSource protocol.
extension SearchViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneIngredientCell", for: indexPath)
        let ingredient = ingredientsList[indexPath.row]
        cell.textLabel?.text = "- \(ingredient.description)"
        return cell
    }
}

//To conform at UITableViewDelegate protocol.
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientsList.remove(at: indexPath.row)
            ingredientsListTableView.deleteRows(at: [indexPath], with: .automatic)
            if ingredientsList.count == 0 {
                toggleButtonState(buttons: [clearButton, searchButton], isEnable: false)
            }
        }
    }
}

// MARK: - Extensions - Segue
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "segueFromSearchToResult" {
           let recipesListVC = segue.destination as? RecipesListViewController
           recipesListVC?.recipesFullData = sender as? RecipeStruct
       }
    }
}
