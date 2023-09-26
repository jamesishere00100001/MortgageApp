//
//  DisclaimerVC.swift
//  MortgageApp
//
//  Created by James Attersley on 25/08/2023.
//

import UIKit

class DisclaimerVC: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var disclaimerTextLabel: UILabel!
    
    private let welcomeText: String    = "Navigating mortgage payments can be confusing. Often, we underestimate the total amount we contribute to banks over the years, especially with fluctuating interest rates.\n\nDiscover your potential savings by exploring the benefits of overpaying your monthly mortgage instalments."
    
    private let disclaimerText: String = "Disclaimer \nThis information does not constitute financial advice, always do your own research to ensure any decision is right for your specific circumstances. If in any doubt consider seeking formal financial advice from a reputable source."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.attributedText           = boldText(string: welcomeText, location: 186, length: 17)
        disclaimerTextLabel.attributedText = boldText(string: disclaimerText, location: 0, length: 10)
    }
    
    //MARK: - Bold sections of text
    
    func boldText(string: String, location: Int, length: Int) -> NSMutableAttributedString {
    
        let atributedString = NSMutableAttributedString(string: string)
        atributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: location, length: length))
        return atributedString
    }
    
    @IBAction func letsGetStartedPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToInitialVC", sender: sender)
    }
}
