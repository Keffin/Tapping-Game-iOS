//
//  HomeViewController.swift
//  tapping-game
//
//  Created by Kevin Alemi on 2020-03-30.
//  Copyright © 2020 Kevin Alemi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var score: UILabel!
    
    
    @IBAction func playButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyBoard.instantiateViewController(identifier: "gameview") as! GameViewController
        
        let nav = UINavigationController()
        nav.modalPresentationStyle = .fullScreen
        nav.viewControllers = [gameViewController]
        self.present(nav, animated: true)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        let userDefaults = Foundation.UserDefaults.standard
        let resetVal = "0"
        score.text = resetVal
        userDefaults.set(resetVal, forKey: "Record")
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Record")
            
        self.navigationController?.isNavigationBarHidden = false
        
        if value == nil {
            score.text = "0"
        }
        else {
            score.text = value
        }
    }
    
    
}


