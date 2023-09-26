//
//  Info.swift
//  MortgageApp
//
//  Created by James Attersley on 08/08/2023.
//

import Foundation

struct Info {
    
    static let mortgageAmount   = ["How much was your mortgage in total?"    : "This is the total sum borrowed from the lender at the beginning of the deal. E.g. the amount you paid for the property minus any deposit amount contributed. \n\nPlease enter whole pounds only."]
    
    static let mortgageTerm     = ["How many years left of your term?"       : "The remaining mortgage term is the number of whole years left to run until the mortgage loan will be paid down to zero, as set out within your original mortgage contract with the lender. \n\nPlease enter whole remaining years only."]
    
    static let initialRate      = ["What's your current interest rate?"      : "The current interest rate is the rate appiled to the loan amount during the deal you have chosen, this may be on a 'fixed' or 'variable' basis."]
    
    static let initialTerm      = ["How long is your current interest deal?" : "Your current interest deal relates to the period when the intial interest rate is applied. This will likely last between two and ten years. \n\nPlease enter whole remaining years only."]
    
    static let standardRate     = ["What is the standard variable rate?"     : "The standard variable rate in the lender's standard variable rate (SVR) to which the mortgage will revert upon completion of the current interest rate deal. \n\nThe standard variable rate will be appilied to the loan until the end of the term or such a time as a new deal is entered into."]
    
    static let overpayment      = ["How much can you overpay per month?"     : "Your overpayment is a sum you are considering paying, over and above the minimum payment, toward you mortgage on a monthly basis to expidite clearing of the debt and minimising the interest accured. \n\nBe aware many lenders apply a limit on total overpayments during a deal period. This is often capped at 10% of total loan over minimum payment per year. Please check with your individual lender for details. \n\nPlease enter whole pounds only."]
    
    func infoRequested(info: String) -> [String: String] {
        
        switch info {
        case "mortgageAmount"   : return Info.mortgageAmount
        case "mortgageTerm"     : return Info.mortgageTerm
        case "initialRate"      : return Info.initialRate
        case "initialTerm"      : return Info.initialTerm
        case "standardRate"     : return Info.standardRate
        case "overpayment"      : return Info.overpayment
            
        default                 : return ["Title error": "Error finding info detail"]
        }
    }
}
