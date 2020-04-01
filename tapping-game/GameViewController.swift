//
//  GameViewController.swift
//  tapping-game
//
//  Created by Kevin Alemi on 2020-03-30.
//  Copyright © 2020 Kevin Alemi. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics

class GameViewController: UIViewController {
    
    //let ball = SKShapeNode(circleOfRadius: 20)
    //var ball: UIView
    //var sceneView: SKView
    //var skView: SKView!
    //var gameScreen: GameScreen!
    @IBOutlet weak var score: UITextField!
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        
        if let view = self.view as! SKView? {
            scene = SKScene(fileNamed: "GameScene") as? GameScene
            scene.viewController = self
            view.presentScene(scene)
            
            /*if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                scene.viewController  = self
            }*/
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        //skView = self.view as? SKView
        //gameScreen = GameScreen(size: skView.bounds.size)
        //skView.presentScene(gameScreen)
        
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
