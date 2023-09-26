//
//  InfoVC.swift
//  MortgageApp
//
//  Created by James Attersley on 08/08/2023.
//

import UIKit

class InfoVC: UIViewController {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var info : [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text     = info.keys.first
        detailLabel.text    = info.values.first
        detailLabel.sizeToFit()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
}
