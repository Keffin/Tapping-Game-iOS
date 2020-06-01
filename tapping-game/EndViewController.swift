//
//  EndViewController.swift
//  tapping-game
//
//  Created by Kevin Alemi on 2020-05-06.
//  Copyright © 2020 Kevin Alemi. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

   
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    var finalScore: String!
    
    
    @IBAction func restartGame(_ sender: Any) {
        //self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        // Do any additional setup after loading the view.
        finalScoreLabel.text = finalScore
        
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }

 

}
