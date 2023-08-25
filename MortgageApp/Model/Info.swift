//
//  Info.swift
//  MortgageApp
//
//  Created by James Attersley on 08/08/2023.
//

import Foundation

struct Info {
    
    static let mortgageAmount   = ["Mortgage Amount" : "This is the total sum borrowed from the lender at the beginning of the deal. E.g. the amount you paid for the property minus any deposit amount contributed."]
    
    static let mortgageTerm     = ["Mortgage Term" : "The mortgage term is the number of whole years left to run until the mortgage loan will be paid down to zero, as set out within your original mortgage contract with the lender."]
    
    static let initialRate      = ["Initial Interest Rate" : "The initial iterest rate is the rate appiled to the loan amount during the deal you have chosen, this may be on a 'fixed' or 'variable' basis."]
    
    static let initialTerm      = ["Initial Rate Term" : "Your initial term relates to the period when the intial interest rate is applied. This will likely last between two and ten years. Please enter whole remaining years."]
    
    static let standardRate     = ["Standard Interest Rate" : "The standard interest rate in the lender's standard variable rate (SVR) to which the mortgage will revert to upon completion of the initial deal term. The standard variable rate will be appilied to the loan until the end of the term or such a time as a new deal is entered into."]
    
    static let overpayment      = ["Proposed Overpayment" : "You proposed overpayment is a sum you are considering paying, over and above the minimum payment, toward you mortgage on a monthly basis to expidite clearing of the debt and minimising the interest accured. \n\nBe aware many lenders apply a limit on total overpayments during a deal period. This is often capped at 10% of total loan over minimum payment per year. Please check with your individual lender for details."]
    
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
