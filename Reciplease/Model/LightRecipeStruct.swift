//
//  LightRecipeStruct.swift
//  Reciplease
//
//  Created by Clément Garcia on 27/04/2022.
//

import Foundation

struct LightRecipeStruct {
    let name: String
    let imageUrl: String
    var ingredients: [LightIngedientStruct]
    let duration: Int
    let rate: Int
    let uri: String
    let recipeUrl: String
}
