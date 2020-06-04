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
import AVFoundation

// Global Const, current workaround
// TODO: Change
let screenSize: CGRect = UIScreen.main.bounds

class GameViewController: UIViewController {
    
 
    @IBOutlet weak var score: UITextField!
    
    var scene: GameScene!
    var audioPlayer = AVAudioPlayer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        
        let sound = Bundle.main.path(forResource: "bgsound", ofType: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer.play()
        } catch {
            print(error)
        }
        
        if let view = self.view as! SKView? {
            // SpriteKit Scene

            scene = SKScene(fileNamed: "GameScene") as? GameScene
            scene.viewController = self
            
            // Set parent scene to enable interaction
            scene.isUserInteractionEnabled = true
            scene.scaleMode = .resizeFill
            // This will set the bottom left corner to our origin, extremely important
            scene.anchorPoint = CGPoint(x: 0, y: 0)
            
            scene.size = view.bounds.size
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }


}
