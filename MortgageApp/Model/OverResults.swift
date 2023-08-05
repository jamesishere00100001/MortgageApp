//
//  OverResults.swift
//  MortgageApp
//
//  Created by James Attersley on 05/08/2023.
//

import Foundation

struct OverResults {
    
    var totalPayableAtTermOver: Double  = 0
    var overPaymentInitial: Double      = 0
    var overPaymentStandard: Double     = 0
    var termOver: Double                = 0
    var paymentSavingOver: Double       = 0
    
    //MARK: - Max overpayment in % per year against mortgageLoan amount (10% is typical in UK)
    
    var maxOverPayment: Double          = 10
}
