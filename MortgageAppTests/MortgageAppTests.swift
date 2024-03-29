//
//  MortgageAppTests.swift
//  MortgageAppTests
//
//  Created by James Attersley on 05/08/2023.
//

import XCTest
@testable import MortgageApp

final class MortgageAppTests: XCTestCase {

    var calculator          = Calculators()
    var enteredLoan         = LoanDetails()
    var calculatedResults   = Results()
    var over                = OverResults()
    var initialVC           = InitialVC()
    
    override func setUpWithError() throws {
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        enteredLoan.mortgageLoan        = 500000
        enteredLoan.mortgageTerm        = 25
        enteredLoan.initialInterestRate = 5
        enteredLoan.intialRateTerm      = 2
        enteredLoan.standardRate        = 8
        enteredLoan.proposedOverPayment = 100
        
        calculatedResults = calculator.paymentCalc(details: enteredLoan)
        
        calculatedResults.initialMonthlyInterestRate  = calculator.paymentCalc(details: enteredLoan).initialMonthlyInterestRate
        calculatedResults.standardMonthlyInterestRate = calculator.paymentCalc(details: enteredLoan).standardMonthlyInterestRate
    }
    
    //MARK: - Payment Calculator tests
    
    func testInitalTermCalc() {
        
        XCTAssertEqual(calculator.paymentCalc(details: enteredLoan).paymentsAtInitialRate, 2922.95, accuracy: 1, "Initial term payment calculation incorrect.")
    }
    
    func testRemainingTermCalc() {
        
        XCTAssertEqual(calculator.paymentCalc(details: enteredLoan).paymentsAtStandardRate, 3859.08, accuracy: 1, "Standard rate payment calculation incorrect.")
    }
    
    func testTotalPayableOutput() {
        
        XCTAssertEqual(calculator.paymentCalc(details: enteredLoan).totalPayabletAtTerm, 1135212, accuracy: 1, "Total payment at loan incorrect.")
    }
    
    //MARK: - Overpayment Calculator tests
    
    func testOverpaymentBeyondMax() {

        enteredLoan.proposedOverPayment = 10000

        XCTAssertThrowsError(try calculator.overPaymentCalc(details: enteredLoan, results: calculatedResults))
    }
    
    func testNormalMortgageTerm() {
        
        XCTAssertEqual(try calculator.overPaymentCalc(details: enteredLoan, results: calculatedResults).paymentSavingOver, 127347, accuracy: 1, "Interest savings figure returned is incorrect.")
    }
    
    func testShortMortgageTerm() {
        
        var alteredLoan = enteredLoan
        alteredLoan.mortgageTerm = 10
        let alteredResults = calculator.paymentCalc(details: alteredLoan)

        XCTAssertEqual(try calculator.overPaymentCalc(details: alteredLoan, results: alteredResults).paymentSavingOver, 36396, accuracy: 1, "Interest savings figure returned is incorrect.")
    }
    
    override func tearDownWithError() throws {
        
        enteredLoan         = LoanDetails()
        calculatedResults   = Results()
        over                = OverResults()
    }
}
