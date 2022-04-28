//
//  FakeRecipeSession.swift
//  RecipleaseTests
//
//  Created by Clément Garcia on 28/04/2022.
//

import Foundation
import Alamofire
@testable import Reciplease

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
    var result: Result<RecipeStruct, AFError>
}

final class FakeRecipeSession: RecipeSessionProtocol {
    // MARK: - Properties
    private let fakeResponse: FakeResponse

    // MARK: - Initializer
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }

    // MARK: - Methods
    func request(url: URL, callback: @escaping (AFDataResponse<RecipeStruct>) -> Void) {
        let dataResponse = AFDataResponse<RecipeStruct>(request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: fakeResponse.result)
        callback(dataResponse)
    }
}
