//
//  ServiceError.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import Foundation

/// Enumeration which list the error case for the services used within the Reciplease app
enum ServiceError: Error {
    case corruptData
    case unexpectedResponse
    case jsonInvalid
    case missingIngredients
    case failureOnlocalLoading
    case failureToEditLocal
}

extension ServiceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .corruptData: return "Data appears to be corrupted."
        case .unexpectedResponse: return "The server provided an unexpected response."
        case .jsonInvalid: return "JSON received doesn't conform to pattern."
        case .missingIngredients: return "No ingredients have been provided"
        case .failureOnlocalLoading: return "Unable to load local data."
        case .failureToEditLocal: return "Unable to set this recipe as favourite"
        }
    }
}
