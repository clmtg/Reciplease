//
//  RecipeSessionProtocol.swift
//  Reciplease
//
//  Created by Clément Garcia on 28/04/2022.
//

import Foundation
import Alamofire

protocol RecipeSessionProtocol {
    func request(url: URL, callback: @escaping (AFDataResponse<RecipeStruct>) -> Void)
}
