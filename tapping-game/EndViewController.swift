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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        // Do any additional setup after loading the view.
        
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }

 

}
