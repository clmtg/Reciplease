//
//  ApiEndpoint.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import Foundation

//Struct which defines endpoints for the Edaman api.
struct ApiEndpoint {
    
    // MARK: - Vars
    //The endpoint to reach. (Part added after the api address. E.g.: myapi.com/path)
    var path: String
    //ParamS to add within the endpoints
    var queryItems: [URLQueryItem] = []
    
    //Full url endpoint
    var url: URL {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

// MARK: - Functions

extension ApiEndpoint {
    
    /// Return the endpoint to reach in order to retreive a recipes lised based on ingredients
    /// - Returns: Endpoint to reach
    static func recipeWith(_ ingredients: [String]) -> URL {
        let endpoint = ApiEndpoint(path: "recipes/v2", queryItems: [
            .init(name: "type", value: "public"),
            .init(name: "app_id", value: AppInfo.appId),
            .init(name: "app_key", value: AppInfo.appKey),
            .init(name: "imageSize", value: "LARGE"),
            .init(name: "q", value: ingredients.joined(separator: ","))
        ])
        return endpoint.url
    }
    
    /// Return the endpoint to reach in order to retreive the a specific recipe
    /// - Returns: Endpoint to reach
    static func recipeForId(_ id: String) -> URL {
        let endpoint = ApiEndpoint(path: "recipes/v2", queryItems: [
            .init(name: "type", value: "public"),
            .init(name: "app_id", value: AppInfo.appId),
            .init(name: "app_key", value: AppInfo.appKey),
            .init(name: "id", value: "id")
        ])
        return endpoint.url
    }
}

