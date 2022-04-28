//
//  RecipeServiceTest.swift
//  RecipleaseTests
//
//  Created by Clément Garcia on 28/04/2022.
//

import XCTest
@testable import Reciplease

class RecipeServiceTests: XCTestCase {
    
    // MARK: - Vars
    var ingredients = ["Lemon", "Flour"]
    
    // MARK: - Tests
    
    func testGivenServiceIsUnavailable_WhenRequestSearch_ErrorIsThrown(){
        let fakeResponse = FakeResponse(response: FakeResponseData.invalidResponse, data: nil, result: .failure(.invalidURL(url: "")) )
        let session = FakeRecipeSession(fakeResponse: fakeResponse)
        let sut = recipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for change")
        sut.searchRecipes(with: ingredients) { result in
            guard case .failure(let error) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(error.isInvalidURLError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenServiceIsAvailable_WhenRequestSearch_ThenProvideResult(){
        
        let fakeResponse = FakeResponse(response: FakeResponseData.validResponse, data: FakeResponseData.correctData, result: .success(FakeResponseData.fakeRecipeStruct))
        let session = FakeRecipeSession(fakeResponse: fakeResponse)
        let sut = recipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for change")
        
        sut.searchRecipes(with: ingredients) { result in
            guard case .success(let data) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(data.count == 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
