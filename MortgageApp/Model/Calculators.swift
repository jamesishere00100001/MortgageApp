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
        
        userResults.totalPayabletAtTerm = (initialTermMonths * userResults.paymentsAtInitialRate) + (remainingTermMonths * userResults.paymentsAtStandardRate)
        
        return userResults
    }

    //MARK: - Overpayment Calculator
    
    mutating func overPaymentCalc(details: LoanDetails, results: Results) throws -> OverResults {

        var over: Double   = 0
        if let overPayment = details.proposedOverPayment {over = overPayment}
        
        let minAnnualPayment = results.paymentsAtInitialRate * 12
        let maxAnnualPayment = minAnnualPayment + (details.mortgageLoan / userResultsOver.maxOverPayment)
        let proposedAnnual   = (results.paymentsAtInitialRate + over) * 12
        let standardPayment  = details.mortgageLoan / results.numberOfPayments
        
        var years      : Double    = 1
        var loanCapital: Double    = details.mortgageLoan
        
        if proposedAnnual <= maxAnnualPayment {
            while loanCapital > proposedAnnual {
                loanCapital -= (standardPayment + over) * 12
                years += 1
            }
            
        } else {
            throw CalculationError.maxOverpayment
        }
        
        func monthlyLoanPayment(loanAmount: Double, interestRate: Double, loanTerm: Double) -> Double {

            let monthlyInterestRate = (interestRate / 100) / 12
            let numberOfPayments    = (loanTerm - years) * 12

            let x = monthlyInterestRate * pow((1 + monthlyInterestRate), numberOfPayments)
            let y = pow((1 + monthlyInterestRate), numberOfPayments) - 1

            return floor(loanAmount * (x / y))
        }
        
        let initialPaymentsWithOver     = (results.paymentsAtInitialRate + over) * 12 * details.intialRateTerm
        
        let remainingPaymentsWithOver   = (results.paymentsAtStandardRate + over) * 12 * (years - details.intialRateTerm)
        
        let annualWithOverpayments      = initialPaymentsWithOver + remainingPaymentsWithOver
        
        userResultsOver.totalPayableAtTermOver  = initialPaymentsWithOver + remainingPaymentsWithOver
        userResultsOver.termOver                = years
        userResultsOver.paymentSavingOver       = results.totalPayabletAtTerm - annualWithOverpayments
        userResultsOver.overPaymentInitial      = results.paymentsAtInitialRate + over
        userResultsOver.overPaymentStandard     = results.paymentsAtStandardRate + over
        
        return userResultsOver
    }
}





