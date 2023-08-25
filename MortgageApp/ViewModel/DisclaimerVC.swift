//
//  DisclaimerVC.swift
//  MortgageApp
//
//  Created by James Attersley on 25/08/2023.
//

import UIKit

class DisclaimerVC: UIViewController {
    
    @IBOutlet weak var disclaimerTextLabel: UILabel!
    
    let disclaimerText: String = "This information does not constitute financial advice, always do your own research to ensure any decision is right for your specific circumstances. If in doubt consider seeking formal financial advice from a reputable source. \n\nBefore overpaying your mortgage, check with your lender that this is allowed and is penalty free. Also whether there are any limits on how much you can overpay, make sure you fully understand how these limits are calculated and the repercussions of exceeding them."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disclaimerTextLabel.text = disclaimerText
    }
    
    @IBAction func OKButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToInitialVC", sender: sender)
    }
    
}
