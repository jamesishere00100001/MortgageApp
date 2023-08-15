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
        
        let initialTermMonths   = details.intialRateTerm * 12
        let remainingTermMonths = (details.mortgageTerm * 12) - initialTermMonths
        
        var over: Double = 0
        if let overPayment = details.proposedOverPayment {
            over = overPayment
        }
        
        let minAnnualPayment = results.paymentsAtInitialRate * 12
        let maxAnnualPayment = minAnnualPayment + (details.mortgageLoan / userResultsOver.maxOverPayment)
        let proposedAnnual = (results.paymentsAtInitialRate + over) * 12
        
        var years: Double = 0
        var loanRemains: Double = results.totalPayabletAtTerm
        
        if proposedAnnual <= maxAnnualPayment {
            while loanRemains > proposedAnnual {
                loanRemains -= proposedAnnual
                years += 1
            }
        } else {
            throw CalculationError.maxOverpayment
        }
        
        let initialPaymentsWithOver     = (results.paymentsAtInitialRate + over) * 12 // * details.intialRateTerm
        
        let remainingPaymentsWithOver   = (results.paymentsAtStandardRate + over) * 12 * (remainingTermMonths / 12)
        
        userResultsOver.totalPayableAtTermOver  = initialPaymentsWithOver * years // + remainingPaymentsWithOver
        userResultsOver.termOver                = years
        userResultsOver.paymentSavingOver       = results.totalPayabletAtTerm - userResultsOver.totalPayableAtTermOver
        userResultsOver.overPaymentInitial      = results.paymentsAtInitialRate + over
        userResultsOver.overPaymentStandard     = results.paymentsAtStandardRate + over
        
        return userResultsOver
    }
}
        //MARK: - Additional info text function
        
//        func additionalInformationText() {
            //        "You will not pay your mortgage off in the current term. Total payable = \(totalPayable) over \(term) years, paying \(totalMonthly) per month, gives \(totalPayment) total payment. This is \(totalPayable - totalPayment) short."
            //
            //            loanDetails.addititonalInfo = "Congratulations you will pay you mortgage off in \(timeLeft)"
            //
            //        "Your total payment will be \(loanDetails.loanPlusInterestAtTerm) and you will be mortgage free in \(timeLeft) years."
        
    
//    }




