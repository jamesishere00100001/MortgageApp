//
//  Constants.swift
//  MortgageApp
//
//  Created by James Attersley on 05/08/2023.
//

import Foundation

struct K {
    
    static let initialSegue             = "goToInitialVC"
    static let resultsSegue             = "goToResultsVC"
    static let infoSegue                = "infoCard"
    
    struct Cell {
        
        static let totalMortage         = "totalMortgage"
        static let totalTerm            = "totalTerm"
        static let payMonthly           = "currentMonthly"
        static let payMonthlyNoDeal     = "currentMonthlyNoDeal"
        static let revisedMortgage      = "revisedMortgage"
        static let interestSaving       = "interestSaving"
        static let revisedTerm          = "revisedTerm"
        static let currentPlusOver      = "currentPlusOver"
        static let currentPlusOverAfter = "currentPlusOverAfter"
    }
}
