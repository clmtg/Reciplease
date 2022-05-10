//
//  StringProtocol.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import Foundation

//Extension of the StringProtocol to add firstUppercased/firstCapitalized options to String value
extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
