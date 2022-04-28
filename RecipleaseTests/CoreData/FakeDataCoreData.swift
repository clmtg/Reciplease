//
//  FakeDataCoreData.swift
//  RecipleaseTests
//
//  Created by Clément Garcia on 28/04/2022.
//

import Foundation
@testable import Reciplease

struct FakeDataCoreData {
    
    // MARK: - Light datas
    
    static let correctLightIngredientsList = [LightIngedientStruct(name: "pizza dough", details: "2 pounds pizza dough"),
                                              LightIngedientStruct(name: "mozzarella cheese", details: "1 1/2 cups shredded mozzarella cheese")]
    
    static let emptyIngredientsList = [LightIngedientStruct]()
    
    
    static let correctLightRecipeWithoutIngredients =  LightRecipeStruct(name: "Pizza Swirl Bread",
                                                       imageUrl: "https://edamam-product-images.s3.amazonaws.com/web-img/3d5/3d538a9e2d5bc91c9a4e204db6872233-l.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEBwaCXVzLWVhc3QtMSJHMEUCIQCfFpz0fLh5JlVChVjw9mQk6KKXYwe%2F5cdVGDwv%2Fod7KwIgLwBJ2OOUbUqoRm16t6E2b1NOud7gBH6g%2F3%2Bm%2FfV6UIQq2wQI1f%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDM8PGLT7LJVvZkIpMSqvBBtwQ9tm%2B2BXDgDSVJuSI3HPPy1bV5AY3%2BktvOH6XwSkXy6aQSk7KdbRekyNmNjuqlXhhcYSP1uRwaQ59kUQpYJKzhLEpU4mF8uz8LYzC4BFyPGh%2BVvgKNV6kVeqAU1CXLiWWbVtNNo%2FszuAh7GZLy1kQfZIARMvMn8EYkH0k6DG0VMpCshkwdNclHV2G3Yx5nBbqp%2BItcWr4eTmi%2BY6JDg7SboCtFT7zWk59AUkmpk7SjMNfe4Mvok27%2FPWMgkOOotq06ViqBarYQpi2djYDYwCr78K7fe73gGcOfOFJRHyPurzTPcUuNbdXONC3LrPphocBc3tGt4WeQK5WCS2V3C%2BW0cNanA%2BgK0VoXqdYgfE0cEz%2FaegHw57LPnapUfuo2HR%2BwwGIU4rFmP1beg1y2vAZFQ6oVq6HK51BfzcLFnuKUzyN18ztSVA%2BThuxW0VGVHT2urduCh%2Bopqjly4UH45GY3Dz8kEu0%2FD388p848HSV1%2BCjxO5aZlr6Fi8m0XtiRePKhSNky3WzJ93qoGfbqZDOO6VmHnGk0%2FFh2VjUpNpKQpzr4K58AhJeVXGbcfB%2BLTQMEkx4zlaTJifEvJUY8nXc2P%2FYeocKA%2BVcE%2FZVEPI6JkcPR2q5BysHWL2hafDi9chWzuV%2BGRLRsxYAZFpn98FpGFTvFVhkoz7lwpEYIzveJLIMCcLnuMqCsQe64USDUyyuZ7QfDLPEmGz3MhZSNLDnXZCtlsM6CHusxNfmGQw%2BPWpkwY6qQFQbHYLTGnnd53ab6hWOchN35TEXc9iDGCGGkBq0oyDIbJZ2S7FjGCLSOoov6z%2B0EybNhP8spKinuzJqZdCQcIrbhBuUaZ46DNrQ7PbwO6jCm6XqLM8zEAN6JzFvjpUTFoj%2FCaFNaJmRLwgUMQLNchdcjXQncl3%2FxkLMcJ4BT%2FtgkBlXb4xxzmF6tutTXqB8YjDK4udu8WhYcZbQEyMdNrnH9vy%2Bdxbg66Y&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220428T121712Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFCP7CMMAM%2F20220428%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=0dc0e049cabe16a8789a61490ab56339ccc45d4c100f882c2ea856dc9c63be25",
                                                       ingredients: [],
                                                       duration: 53,
                                                       rate: 4,
                                                       uri: "http://www.edamam.com/ontologies/edamam.owl#recipe_eaa6ad008fea42ff09b039f835d0e3db",
                                                       recipeUrl: "http://www.edamam.com/recipe/pizza-swirl-bread-eaa6ad008fea42ff09b039f835d0e3db/bread%2Ccheese%2Cpizza%2Ctomato"
    )
    
    static let correctLightRecipeWithIngredients =  LightRecipeStruct(name: "Pizza Swirl Bread",
                                                       imageUrl: "https://edamam-product-images.s3.amazonaws.com/web-img/3d5/3d538a9e2d5bc91c9a4e204db6872233-l.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEBwaCXVzLWVhc3QtMSJHMEUCIQCfFpz0fLh5JlVChVjw9mQk6KKXYwe%2F5cdVGDwv%2Fod7KwIgLwBJ2OOUbUqoRm16t6E2b1NOud7gBH6g%2F3%2Bm%2FfV6UIQq2wQI1f%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDM8PGLT7LJVvZkIpMSqvBBtwQ9tm%2B2BXDgDSVJuSI3HPPy1bV5AY3%2BktvOH6XwSkXy6aQSk7KdbRekyNmNjuqlXhhcYSP1uRwaQ59kUQpYJKzhLEpU4mF8uz8LYzC4BFyPGh%2BVvgKNV6kVeqAU1CXLiWWbVtNNo%2FszuAh7GZLy1kQfZIARMvMn8EYkH0k6DG0VMpCshkwdNclHV2G3Yx5nBbqp%2BItcWr4eTmi%2BY6JDg7SboCtFT7zWk59AUkmpk7SjMNfe4Mvok27%2FPWMgkOOotq06ViqBarYQpi2djYDYwCr78K7fe73gGcOfOFJRHyPurzTPcUuNbdXONC3LrPphocBc3tGt4WeQK5WCS2V3C%2BW0cNanA%2BgK0VoXqdYgfE0cEz%2FaegHw57LPnapUfuo2HR%2BwwGIU4rFmP1beg1y2vAZFQ6oVq6HK51BfzcLFnuKUzyN18ztSVA%2BThuxW0VGVHT2urduCh%2Bopqjly4UH45GY3Dz8kEu0%2FD388p848HSV1%2BCjxO5aZlr6Fi8m0XtiRePKhSNky3WzJ93qoGfbqZDOO6VmHnGk0%2FFh2VjUpNpKQpzr4K58AhJeVXGbcfB%2BLTQMEkx4zlaTJifEvJUY8nXc2P%2FYeocKA%2BVcE%2FZVEPI6JkcPR2q5BysHWL2hafDi9chWzuV%2BGRLRsxYAZFpn98FpGFTvFVhkoz7lwpEYIzveJLIMCcLnuMqCsQe64USDUyyuZ7QfDLPEmGz3MhZSNLDnXZCtlsM6CHusxNfmGQw%2BPWpkwY6qQFQbHYLTGnnd53ab6hWOchN35TEXc9iDGCGGkBq0oyDIbJZ2S7FjGCLSOoov6z%2B0EybNhP8spKinuzJqZdCQcIrbhBuUaZ46DNrQ7PbwO6jCm6XqLM8zEAN6JzFvjpUTFoj%2FCaFNaJmRLwgUMQLNchdcjXQncl3%2FxkLMcJ4BT%2FtgkBlXb4xxzmF6tutTXqB8YjDK4udu8WhYcZbQEyMdNrnH9vy%2Bdxbg66Y&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220428T121712Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFCP7CMMAM%2F20220428%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=0dc0e049cabe16a8789a61490ab56339ccc45d4c100f882c2ea856dc9c63be25",
                                                                      ingredients: FakeDataCoreData.correctLightIngredientsList,
                                                       duration: 53,
                                                       rate: 4,
                                                       uri: "http://www.edamam.com/ontologies/edamam.owl#recipe_eaa6ad008fea42ff09b039f835d0e3db",
                                                       recipeUrl: "http://www.edamam.com/recipe/pizza-swirl-bread-eaa6ad008fea42ff09b039f835d0e3db/bread%2Ccheese%2Cpizza%2Ctomato"
    )
    
    // MARK: - Local data, within CoreDataStorage
    
}


