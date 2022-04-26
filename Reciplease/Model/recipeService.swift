//
//  recipeService.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import Foundation
import Alamofire

/// Handle the service related to the Edaman API
final class recipeService {
    
    // MARK: - var
    //Session and data task used to perform API calls
    private let sessionManager: Session
    
    //Class initializer
    init(session: Session = .default) {
        self.sessionManager = session
    }
    
    /// Search a recipes list based on ingredients provided
    /// - Parameters:
    ///   - ingredients: ingreditens which must be within recipes
    ///   - completionHandler: call to perform once result (sucess/failure) is available
    func searchRecipes(with ingredients: [String], completionHandler: @escaping (Result<RecipeStruct, AFError>) -> Void) {
        loadNextPage(for: ApiEndpoint.recipeWith(ingredients), completionHandler: completionHandler)
    }
    
    /// Retrieve the recipes list for a specific page
    /// - Parameters:
    ///   - page: page url to load
    ///   - completionHandler: call to perform once result (sucess/failure) is available
    func loadNextPage(for page: URL, completionHandler: @escaping (Result<RecipeStruct, AFError>) -> Void) {
        let request = sessionManager.request(page)
        request.responseDecodable(of: RecipeStruct.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
