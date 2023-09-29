//
//  Calculators.swift
//  MortgageApp
//
//  Created by James Attersley on 05/08/2023.
//
import Foundation

struct Calculators {
    
    var userResults     = Results()
    var userResultsOver = OverResults()
    
    enum CalculationError: Error {
        case maxOverpayment
    }
    
    //MARK: - Payment Calculators
    
    mutating func paymentCalc(details: LoanDetails) -> Results {
        
        let initialTermMonths   = details.intialRateTerm * 12
        let remainingTermMonths = (details.mortgageTerm * 12) - initialTermMonths
        
        //MARK: - Initial term payment calc
        
        userResults.initialMonthlyInterestRate = (details.initialInterestRate / 100) / 12
        userResults.numberOfPayments = details.mortgageTerm * 12
        
        let x = userResults.initialMonthlyInterestRate * pow((1 + userResults.initialMonthlyInterestRate), userResults.numberOfPayments)
        let y = pow((1 + userResults.initialMonthlyInterestRate), userResults.numberOfPayments) - 1
        
        userResults.paymentsAtInitialRate = floor(details.mortgageLoan * (x / y))
        
        //MARK: - Remaining term at standard rate calc
        
        userResults.standardMonthlyInterestRate = (details.standardRate / 100) / 12
        
        let a = userResults.standardMonthlyInterestRate * pow((1 + userResults.standardMonthlyInterestRate), userResults.numberOfPayments)
        let b = pow((1 + userResults.standardMonthlyInterestRate), userResults.numberOfPayments) - 1
        
        userResults.paymentsAtStandardRate = floor(details.mortgageLoan * (a / b))
        
        //MARK: - Total amount payable at term
        
        userResults.numberOfInitalPayments   = initialTermMonths
        userResults.numberOfStandardPayments = remainingTermMonths
        userResults.totalPayabletAtTerm      = (initialTermMonths * userResults.paymentsAtInitialRate) + (remainingTermMonths * userResults.paymentsAtStandardRate)
        
        return userResults
    }

    //MARK: - Overpayment Calculator
    
    
    mutating func overPaymentCalc(details: LoanDetails, results: Results) throws -> OverResults {
        
        var over: Double   = 0
        if let overPayment = details.proposedOverPayment { over = overPayment }
        
        let minInitialAnnual        = results.paymentsAtInitialRate * 12
        let maxAnnualPayment        = minInitialAnnual + (details.mortgageLoan / userResultsOver.maxOverPayment)
        let proposedInitialMonthly  = results.paymentsAtInitialRate
        let proposedStandardMonthly = results.paymentsAtStandardRate
        let proposedInitalAnnual    = (proposedInitialMonthly + over) * 12
        
        var months         : Double = 0
        var initialTerm    : Double = results.numberOfInitalPayments
        var remainingTerm  : Double = results.numberOfStandardPayments
        
        var loan                = details.mortgageLoan
        var currentInterestRate = details.initialInterestRate
        
        if over > 0 {
            
            let principalReduction = over
            loan -= principalReduction
        }
        
        if proposedInitalAnnual > maxAnnualPayment {
    
            throw CalculationError.maxOverpayment
        }
        
        while loan > 0 {
       
            let monthlyInterestRate    = (currentInterestRate / 100) / 12
            let monthlyInterestPayment = loan * monthlyInterestRate
            var monthlyPrincipalPayment: Double = 0
            
            if initialTerm > 0 {
                monthlyPrincipalPayment = proposedInitialMonthly - monthlyInterestPayment
            } else if remainingTerm > 0 {
                monthlyPrincipalPayment = proposedStandardMonthly - monthlyInterestPayment
            }
            
            if initialTerm > 0 {
                if loan > proposedInitialMonthly {
                    loan -= monthlyPrincipalPayment
                    months += 1
                    initialTerm -= 1
                } else {
                    break
                }
            } else if remainingTerm > 0 {
                if loan > proposedStandardMonthly {
                    loan -= monthlyPrincipalPayment
                    months += 1
                    remainingTerm -= 1
                } else {
                    break
                }
            } else {
                break
            }
            
            if initialTerm == 0 && currentInterestRate != details.standardRate {
                currentInterestRate = details.standardRate
            }
        }
        
        let revisedTermStandard         = months - results.numberOfInitalPayments
        let initialPaymentsWithOver     = proposedInitialMonthly * results.numberOfInitalPayments
        let remainingPaymentsWithOver   = proposedStandardMonthly * revisedTermStandard
        let revisedWithOverpayments     = initialPaymentsWithOver + remainingPaymentsWithOver
        
        userResultsOver.totalPayableAtTermOver = revisedWithOverpayments
        userResultsOver.termOver               = months / 12
        userResultsOver.paymentSavingOver      = results.totalPayabletAtTerm - revisedWithOverpayments
        userResultsOver.overPaymentInitial     = proposedInitialMonthly + over
        userResultsOver.overPaymentStandard    = proposedStandardMonthly + over
        
        return userResultsOver
    }
}





