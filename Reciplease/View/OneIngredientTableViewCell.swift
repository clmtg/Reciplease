//
//  OneIngredientTableViewCell.swift
//  Reciplease
//
//  Created by Clément Garcia on 02/05/2022.
//

import UIKit

class OneIngredientTableViewCell: UITableViewCell {
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var oneIngredientLabel: UILabel!
    
    // MARK: - Functions
    func configure(with ingredient: String) {
        oneIngredientLabel.text = ingredient
    }
}
