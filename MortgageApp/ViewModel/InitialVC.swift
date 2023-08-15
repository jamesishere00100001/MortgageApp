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
    
    private var info            = Info()
    private var infoData        : [String : String] = [:]
    
    enum Errors: String, Error {
        
        case maxOverpayment     = "Proposed overpayment exceeds maxiumum allowed within deal."
        case invalidCharacter   = "Invalid character entered."
        case tooManyDigits      = "Too many digits entered."
        case fillAllDetails     = "Please fill all details to proceed."
        case unknown            = "Uknown error: Please check entered details."
    }

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
            if containsDigits(input) == true {
                presentError(error: .invalidCharacter)
            }
            
            if input.count >= 8  {
                presentError(error: .tooManyDigits)
            }
            
            return Double(input) ?? 0
        }
        
        presentError(error: .fillAllDetails)
        return 0
    }
    
    //MARK: - User inputs

    func updateUserInputs() {
        
        userDetails.mortgageLoan            = checkString(mortgageAmountField.text)
        userDetails.initialInterestRate     = checkString(initialInterestField.text)
        userDetails.intialRateTerm          = checkString(initialRateTerm.text)
        userDetails.standardRate            = checkString(standardInterestField.text)
        userDetails.mortgageTerm            = checkString(termField.text)
        userDetails.proposedOverPayment     = checkString(proposedOverPaymentField.text)
    }
    
    func containsDigits(_ input: String) -> Bool {
        let acceptableEntry = ".*[0-9]+.*"
        let predicate       = NSPredicate(format: "SELF MATCHES %@", acceptableEntry)
        return !predicate.evaluate(with: input)
    }
    
    //MARK: - Present alert for error
    
    func presentError(error: Errors) {
        let alert        = UIAlertController(title: "Oops", message: error.rawValue, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    //MARK: - Go! button
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        
        updateUserInputs()
        userResults     = calculator.paymentCalc(details: userDetails)
        
        do {
            try userResultsOver = calculator.overPaymentCalc(details: userDetails, results: userResults)
        } catch Errors.maxOverpayment {

            presentError(error: .maxOverpayment)
        } catch {
            
            presentError(error: .unknown)
        }
        
        self.performSegue(withIdentifier: K.resultsSegue, sender: self)
    }
    
    //MARK: - Reset button
    
    @IBAction func resetButtonPressed(_ sender: UIBarButtonItem) {
        
        userDetails     = LoanDetails()
        userResults     = Results()
        userResultsOver = OverResults()
        
        mortgageAmountField.text        = ""
        initialInterestField.text       = ""
        initialRateTerm.text            = ""
        standardInterestField.text      = ""
        termField.text                  = ""
        proposedOverPaymentField.text   = ""
    }
    
    //MARK: - Info buttons
    
    @IBAction func mortgageAmountInfo(_ sender: UIButton) {
        infoData = info.infoRequested(info: "mortgageAmount")
        
        self.performSegue(withIdentifier: K.infoSegue, sender: sender)
    }
    
    @IBAction func mortgageTermInfo(_ sender: UIButton) {
        infoData = info.infoRequested(info: "mortgageTerm")
        
        self.performSegue(withIdentifier: K.infoSegue, sender: sender)
    }
    
    @IBAction func initialInterestInfo(_ sender: UIButton) {
        infoData = info.infoRequested(info: "initialRate")
        
        self.performSegue(withIdentifier: K.infoSegue, sender: sender)
    }
    
    @IBAction func initialTerm(_ sender: UIButton) {
        infoData = info.infoRequested(info: "initialTerm")
        
        self.performSegue(withIdentifier: K.infoSegue, sender: sender)
    }
    
    @IBAction func standardRate(_ sender: UIButton) {
        infoData = info.infoRequested(info: "standardRate")
        
        self.performSegue(withIdentifier: K.infoSegue, sender: sender)
    }
    
    @IBAction func overpayment(_ sender: UIButton) {
        infoData = info.infoRequested(info: "overpayment")
        
        self.performSegue(withIdentifier: K.infoSegue, sender: sender)
    }
    
    //MARK: - Prepare for segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.resultsSegue {
            let destinationVC = segue.destination as! ResultsVC
            
            destinationVC.userDetails       = self.userDetails
            destinationVC.userResults       = self.userResults
            destinationVC.userResultsOver   = self.userResultsOver
        } else if segue.identifier == K.infoSegue {
            
                let destinationVC = segue.destination as! InfoVC
                
                destinationVC.info = self.infoData
        }
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


