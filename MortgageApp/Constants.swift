//
//  Constants.swift
//  MortgageApp
//
//  Created by James Attersley on 05/08/2023.
//

import Foundation

struct K {
    
    static let resultsSegue             = "goToResultsVC"
    static let infoSegue                = "infoCard"
    
    struct Cell {
        
        static let totalMortage         = "totalMortgage"
        static let totalTerm            = "totalTerm"
        static let payMonthly           = "currentMonthly"
        static let payMonthlyNoDeal     = "currentMonthlyNoDeal"
        static let revisedMortgage      = "revisedMortgage"
        static let revisedTerm          = "revisedTerm"
        static let currentPlusOver      = "currentPlusOver"
        static let currentPlusOverAfter = "currentPlusOverAfter"
    }
    
    struct Info {
        
        static let titleText  = ""
        static let detailText = "Mortgage amount : This the total sum borrowed from the lender at the beginning of the deal. E.g. the amount you paid for the                        property minus any deposit amount contributed."
    }
}
