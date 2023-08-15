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
    
    override func setUpWithError() throws {
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        enteredLoan.mortgageLoan        = 500000
        enteredLoan.mortgageTerm        = 25
        enteredLoan.initialInterestRate = 5
        enteredLoan.intialRateTerm      = 25
        enteredLoan.standardRate        = 8
        enteredLoan.proposedOverPayment = 100
        
        calculatedResults.initialMonthlyInterestRate = calculator.paymentCalc(details: enteredLoan).initialMonthlyInterestRate
        calculatedResults.standardMonthlyInterestRate = calculator.paymentCalc(details: enteredLoan).standardMonthlyInterestRate
//        calculatedResults.numberOfPayments = calculator.paymentCalc(details: enteredLoan).numberOfPayments
//        calculatedResults.paymentsAtInitialRate = ca
//        calculatedResults.paymentsAtStandardRate
//        calculatedResults.totalPayabletAtTerm
    }
    
    //MARK: - Payment Calculator tests
    
    func testInitalTermCalc() {
        
        XCTAssertEqual(calculator.paymentCalc(details: enteredLoan).paymentsAtInitialRate, 2922.95, accuracy: 1, "Initial term payment calculation incorrect.")
    }
    
    func testRemainingTermCalc() {
        
        XCTAssertEqual(calculator.paymentCalc(details: enteredLoan).paymentsAtStandardRate, 3859.08, accuracy: 1, "Standard rate payment calculation incorrect.")
    }
    
    func testTotalPayableOutput() {
        
        XCTAssertEqual(calculator.paymentCalc(details: enteredLoan).totalPayabletAtTerm, 876600, accuracy: 1, "Total payment at loan incorrect.")
    }
    
    //MARK: - Overpayment Calculator tests
    
    func testOverpaymentBeyondMax() {

        enteredLoan.proposedOverPayment = 10000

        XCTAssertThrowsError(try calculator.overPaymentCalc(details: enteredLoan, results: calculatedResults))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        enteredLoan         = LoanDetails()
        calculatedResults   = Results()
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
