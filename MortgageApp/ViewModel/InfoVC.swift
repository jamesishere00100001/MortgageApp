//
//  InfoVC.swift
//  MortgageApp
//
//  Created by James Attersley on 08/08/2023.
//

import UIKit

class InfoVC: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var infoLabel: UINavigationItem!
    
    var info : [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.title     = info.keys.first
        detailLabel.text    = info.values.first
        detailLabel.sizeToFit()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
    
}
