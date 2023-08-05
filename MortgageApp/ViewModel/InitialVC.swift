//
//  InitialVC.swift
//  MortgageApp
//
//  Created by James Attersley on 05/08/2023.
//

import UIKit

class InitialVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mortgageAmountField: UITextField!
    @IBOutlet weak var initialInterestField: UITextField!
    @IBOutlet weak var initialRateTerm: UITextField!
    @IBOutlet weak var standardInterestField: UITextField!
    @IBOutlet weak var termField: UITextField!
    @IBOutlet weak var proposedOverPaymentField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    private var calculator      = Calculators()
    private var userDetails     = LoanDetails()
    private var userResults     = Results()
    private var userResultsOver = OverResults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Soft keyboard notification
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            scrollView.addGestureRecognizer(tapGesture)
        
        scrollView.isScrollEnabled = true
    }
    
    //MARK: - Check and update user inputs
    
    func checkString(_ userString: String?) -> Double {
        
        if let input = userString {
            if containsDigit(input) == true {
                presentError(error: "Invalid character")
            }
            
            if input.count >= 8  {
                presentError(error: "Too many digits")
            }
            
            return Double(input)!
        }
        
        presentError(error: "Please fill all details")
        return 0
    }
    
    //MARK: - User inputs

    func updateUserInputs() {
        
        userDetails.mortgageLoan            = checkString(mortgageAmountField.text)
        userDetails.initialInterestRate     = checkString(initialInterestField.text)
        userDetails.intialRateTerm          = checkString(initialRateTerm.text)
        userDetails.standardRate            = checkString(initialInterestField.text)
        userDetails.mortgageTerm            = checkString(termField.text)
        userDetails.proposedOverPayment     = checkString(proposedOverPaymentField.text)
    }
    
    func containsDigit(_ input: String) -> Bool {
        let acceptableEntry = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", acceptableEntry)
        return !predicate.evaluate(with: input)
    }
    
    func presentError(error: String) {
        let alert = UIAlertController(title: "Oops", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    //MARK: - Go! button pressed segue
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        
        updateUserInputs()

        userResults = calculator.paymentCalc(details: userDetails)
        userResultsOver = calculator.overPaymentCalc(details: userDetails, results: userResults)

        userResults = calculateResults(userData: userDetails)
        

        self.performSegue(withIdentifier: K.resultsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.resultsSegue {
            let destinationVC = segue.destination as! ResultsVC
            destinationVC.userDetails = self.userDetails
            destinationVC.userResults = self.userResults

            destinationVC.userResultsOver = self.userResultsOver
        }
    }
    
    func calculateResults(userData data: LoanDetails) -> Results {
        return calculator.paymentCalc(details: data)
        
    }

    //MARK: - Soft keyboard scroll func - Works in conjuction with notificationCentre set up in viewDidLoad
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


