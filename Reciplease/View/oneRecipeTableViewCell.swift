//
//  oneRecipeTableViewCell.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import UIKit
import Kingfisher

class oneRecipeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var likesAccountLabel: UILabel!
    @IBOutlet weak var recipeDuration: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    // MARK: - Function
    /// Configure the cell based on the information provided
    /// - Parameters:
    ///   - cityName: Name of the affected city
    ///   - condition: Affected city condition
    ///   - temp: Affected city tempersatures
    func configure(for recipeName: String, ingredientsLine: String, rearImage: URL, duration: Int, yield: Int) {
        cellImageView.kf.setImage(with: rearImage, options: [.transition(.fade(0.2))])
        recipeNameLabel.text = recipeName.firstUppercased
        ingredientsLabel.text = ingredientsLine
        recipeDuration.text = "\(duration)"
        likesAccountLabel.text = "\(yield)"
    }
}
