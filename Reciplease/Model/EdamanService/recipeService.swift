//
//  RecipeService.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import Foundation
import Alamofire

/// Handle the service related to the Edaman API
final class RecipeService {
    
    // MARK: - Properties
    private let session: RecipeSessionProtocol
    
    // MARK: - Initializer
    init(session: RecipeSessionProtocol = RecipeSession()) {
        self.session = session
    }
    
    /// Search a recipes list based on ingredients provided
    /// - Parameters:
    ///   - ingredients: ingreditens which must be within recipes
    ///   - completionHandler: call to perform once result (sucess/failure) is available
    func searchRecipes(with ingredients: [String], completionHandler: @escaping (Result<RecipeStruct, AFError>) -> Void) {
        loadNextPage(for: ApiEndpoint.recipeWith(ingredients), completionHandler: completionHandler)
    }
    
    /// Retreive data for a specific url page.
    /// - Parameters:
    ///   - page: page related to the data to load
    ///   - completionHandler: call to perform once result (sucess/failure) is available
    func loadNextPage(for page: URL, completionHandler: @escaping (Result<RecipeStruct, AFError>) -> Void) {
        session.request(url: page) { response in
            guard case .success(let data)  = response.result else {
                completionHandler(.failure(response.error!))
                return
            }
            completionHandler(.success(data))
        }
    }
}
