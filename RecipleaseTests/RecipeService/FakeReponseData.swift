//
//  FakeReponseData.swift
//  RecipleaseTests
//
//  Created by Clément Garcia on 28/04/2022.
//

import Foundation
import Alamofire
@testable import Reciplease

final class FakeResponseData {
    
    // MARK: - URL
    static let serviceUrl: URL = ApiEndpoint.recipeWith(["Lemon", "Flour"])

    // MARK: - Responses
    static let validResponse = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let invalidResponse = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // MARK: - Data
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        return bundle.dataFromJson("edamanApiResult")
    }
    
    static let fakeRecipeStruct = RecipeStruct(from: 0, to: 0, count: 0, links: nil, hits: [])

    static let incorrectData = "erreur".data(using: .utf8)!
}

// MARK: - Extensions related to Bundle
extension Bundle {
    
    /// Extract data to a json file
    /// - Parameter name: json file name
    /// - Returns: data
    func dataFromJson(_ name: String) -> Data {
        guard let mockURL = url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: mockURL) else {
            fatalError("Failed to load \(name) from bundle.")
        }
        return data
    }
}

