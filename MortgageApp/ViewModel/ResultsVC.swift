//
//  ResultsVC.swift
//  MortgageApp
//
//  Created by James Attersley on 05/08/2023.
//

import UIKit

class ResultsVC: UITableViewController {
    
    var userResults     = Results()
    var userDetails     = LoanDetails()
    var userResultsOver = OverResults()
    
    var cellSeries: [[String]] = [[K.Cell.totalMortgage,
                                   K.Cell.totalTerm,
                                   K.Cell.payMonthly,
                                   K.Cell.payMonthlyNoDeal],
                                  
                                  [K.Cell.revisedMortgage,
                                   K.Cell.interestSaving,
                                   K.Cell.revisedTerm,
                                   K.Cell.currentPlusOver,
                                   K.Cell.currentPlusOverAfter]]
    
    let cellLabel: [[String]]  = [["Total mortgage payment",
                                   "Years left",
                                   "Monthly payment with current interest deal",
                                   "Monthly payment outside your current deal"],
                                  
                                  ["Total mortgage payment",
                                   "Gross total saving",
                                   "Years left",
                                   "Monthly payment with current interest deal",
                                   "Monthly payment outside your current deal"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 72.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: - Format user input and calculated data
    
    func formatData(details: LoanDetails, result: Results, over: OverResults) -> [[String]] {
        
        let cellArray: [[String]] = [[currencyString(result.totalPayabletAtTerm),
                                      doubleToString(details.mortgageTerm),
                                      currencyString(result.paymentsAtInitialRate),
                                      currencyString(result.paymentsAtStandardRate)],
                                     
                                     [currencyString(over.totalPayableAtTermOver),
                                      currencyString(over.paymentSavingOver),
                                      doubleToString(over.termOver),
                                      currencyString(over.overPaymentInitial),
                                      currencyString(over.overPaymentStandard)]]
        return cellArray
    }
    
    func doubleToString(_ double: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        if let number = formatter.string(from: double as NSNumber) {
            return number
        }
        
        return "error"
    }
    
    func currencyString(_ double: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_GB")
        formatter.maximumFractionDigits = 0
        
        if let currency = formatter.string(from: double as NSNumber) {
            return currency
        }
        
        return "£error"
    }
    
    //MARK: - Share button - Take screenshot and present sharesheet
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    //MARK: - Tableview delegate and datasource
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "Text")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellSeries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellSeries[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Your current deal result without overpayment"
        case 1:
            return "Results with £\(Int(userDetails.proposedOverPayment ?? 0)) monthly overpayment"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = formatData(details: userDetails, result: userResults, over: userResultsOver)
        
        let cell     = tableView.dequeueReusableCell(withIdentifier: cellSeries[indexPath.section][indexPath.row], for: indexPath)
        let label    = cellLabel[indexPath.section][indexPath.row]
        let results  = cellData[indexPath.section][indexPath.row]
        
        cell.textLabel?.text       = label
        cell.detailTextLabel?.text = results
        
        return cell
    }
}



