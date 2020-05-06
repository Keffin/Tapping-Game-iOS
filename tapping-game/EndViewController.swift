//
//  EndViewController.swift
//  tapping-game
//
//  Created by Kevin Alemi on 2020-05-06.
//  Copyright © 2020 Kevin Alemi. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        // Do any additional setup after loading the view.
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
