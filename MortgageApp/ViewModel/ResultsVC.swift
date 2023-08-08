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
    
    var cellSeries: [[String]] = [[K.Cell.totalMortage,
                                   K.Cell.totalTerm,
                                   K.Cell.payMonthly],
                                  
                                  [K.Cell.payMonthlyNoDeal],
                                  
                                  [K.Cell.revisedMortgage,
                                   K.Cell.revisedTerm,
                                   K.Cell.currentPlusOver,
                                   K.Cell.currentPlusOverAfter]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
    }
    
    //MARK: - Format user input and calculated data
    
    func formatData(details: LoanDetails, result: Results, over: OverResults) -> [[String]] {
        
        let cellArray: [[String]] = [[currencyString(result.totalPayabletAtTerm),
                                      doubleToString(details.mortgageTerm),
                                      currencyString(result.paymentsAtInitialRate)],
                                     
                                     [currencyString(result.paymentsAtStandardRate)],
                                     
                                     [currencyString(over.totalPayableAtTermOver),
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellSeries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellSeries[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Current results"
        case 1:
            return "Out of deal"
        case 2:
            return "Overpayment results"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = formatData(details: userDetails, result: userResults, over: userResultsOver)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellSeries[indexPath.section][indexPath.row], for: indexPath)
        let results = cellData[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = results
        
        return cell
    }
}


