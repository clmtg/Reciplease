//
//  RecipeSession.swift
//  Reciplease
//
//  Created by Clément Garcia on 28/04/2022.
//

import Foundation
import Alamofire

final class RecipeSession: RecipeSessionProtocol {
    func request(url: URL, callback: @escaping (AFDataResponse<RecipeStruct>) -> Void) {
        AF.request(url).responseDecodable(of: RecipeStruct.self) { dataResponse in
            callback(dataResponse)
        }
    }
    
}
