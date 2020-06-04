//
//  GameScene.swift
//  tapping-game
//
//  Created by Kevin Alemi on 2020-04-01.
//  Copyright © 2020 Kevin Alemi. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics
import GameplayKit
import AVFoundation



class GameScene: SKScene {
    
    // MARK: Properties
    weak var viewController: GameViewController!
    
    // This is the list of nodes displayed on the screen
    private var nodeList: [SKShapeNode] = []
    private var duckList: [SKNode] = []
    private var bomb: SKSpriteNode? = nil
    private var bombList: [SKNode] = []
    private var shouldSpawnBomb: Bool = false
    private static var backgroundMusicPlayer: AVAudioPlayer!
    
    
    var highScore: String!
    
    
    var duckAnimation: SKAction!
    
    var endButton: SKSpriteNode!
    
    let blastSound = SKAction.playSoundFileNamed("pling", waitForCompletion: false)
    let tickSound = SKAction.playSoundFileNamed("tick", waitForCompletion: false)
    let explodeSound = SKAction.playSoundFileNamed("explode", waitForCompletion: false)
    
    override func update(_ currentTime: TimeInterval) {
        // Change this to 10 later
        super.update(currentTime)
        
        
        
        if shouldSpawnBomb {
            shouldSpawnBomb = false
            self.bomb = SKSpriteNode(imageNamed: "bomb")
            self.bomb!.size = CGSize(width: 50, height: 50)
            //self.bomb = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 20, height: 20))
            self.bomb!.name = "bomb"
            let xCord = screenSize.minX + 38
            let yCord = screenSize.minY + 30
            self.bomb!.position = CGPoint(x: xCord, y: yCord)
            // Sets bomb to be front view all the time
            self.bomb!.zPosition = 1
            addChild(self.bomb!)
            run(blastSound)
        }
        
    }
    
   
    
    
    override func didMove(to view: SKView) {
        // if difficulity == easy => forDuration: 7
        // if difficulity == medium => forDuration: 5
        // if difficulity == hard => forDuration: 2
        
        endButton = SKSpriteNode(color: .red, size: CGSize(width: 70, height: 40))
        endButton.position = CGPoint(x: (screenSize.maxX / 2), y: screenSize.minY + 35)
        
        endButton.name = "end"
        
        let lbl = SKLabelNode(fontNamed: "Menlo")
        lbl.text = "End Game"
        lbl.fontSize = 14
        lbl.fontColor = .black
        //lbl.position = CGPoint(x: (screenSize.maxX / 2), y: screenSize.minY + 30)
        lbl.horizontalAlignmentMode = .center
        lbl.verticalAlignmentMode = .center
        lbl.name = "end"
        
        endButton.addChild(lbl)
        addChild(endButton)
        
        
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Record")
        highScore = value
        
        animateDuck()
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(duckSpawn),
            SKAction.wait(forDuration: 1)
            ])
        ))
    }
    
    // Simple touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let w = (self.size.width + self.size.height) * 0.01
        
        for t in touches {
            self.nodeList.append(SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3))
            
            // osäker om detta?
            //self.touchDown(atPoint: t.location(in: self))
            
            let location = t.location(in: self)
            let touchedNodes = nodes(at: location)
            
            let touchedBomb = atPoint(location)
            
            if touchedBomb.name != "bomb" {
                // Checks if the touched location is a node with the property name "duck", in that case we remove it
                duckList = touchedNodes.filter { $0.name == "duck"}
                
                if !duckList.isEmpty {
                    self.duckList.first?.removeFromParent()
                    self.scoreBoard()
                }
            }
            else {
                self.bomb!.position = location
            }
            
        }
    }
    
   
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.bomb = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if self.bomb != nil {
            //let location = touches.first!.location(in: self)
            
            for touch in touches {
                let loc = touch.location(in: self)
                let touchedBomb = atPoint(loc)
                if touchedBomb.name == "bomb" {
                    self.bomb!.position = loc
                }
            }
        }
        
    
    }
    
   
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesEnded(touches, with: event)
        
        for touch in touches {
        
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "end" {
                
                
                if highScore == nil {
                    let savedString = viewController.score.text
                    let userDefaults = Foundation.UserDefaults.standard
                    userDefaults.set(savedString, forKey: "Record")
                }
                else {
                    let score = Int(viewController.score.text!)
                    let highestScore = Int(highScore)
                    
                    if score! > highestScore! {
                        let savedString = viewController.score.text
                        let userDefaults = Foundation.UserDefaults.standard
                        userDefaults.set(savedString, forKey: "Record")
                    }
                }
                
                
                
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let endViewController = storyBoard.instantiateViewController(identifier: "endview") as! EndViewController
                
                endViewController.modalPresentationStyle = .fullScreen
                
                endViewController.finalScore = viewController.score.text
                
                self.viewController.navigationController?.pushViewController(endViewController, animated: true)
                //self.view?.window?.rootViewController?.present(endViewController, animated: true, completion: ni)
                //self.view?.window?.rootViewController?.present(endViewController, animated: true, completion: nil)
                self.viewController.audioPlayer.pause()
                
            }
            
            
            if touchedNode.name == "bomb" {
                if self.bomb != nil  {
                    
                    // "Explode" after 2.0 seconds
                    //run(tickSound)
                    self.bomb?.run(SKAction.sequence([SKAction.wait(forDuration: 0.3),
                                                      SKAction.removeFromParent(),
                                                      explodeSound
                                                    ]))
                    
                    let currentX = Int(self.bomb!.position.x)
                    let currentY = Int(self.bomb!.position.y)
                    for currentX in currentX...Int(currentX+50) {
                        for currentY in currentY...Int(currentY+50) {
                            let pX = CGFloat(currentX)
                            let pY = CGFloat(currentY)
                            let p = CGPoint(x: pX, y: pY)
                            let nodeLoc = atPoint(p)
                            if nodeLoc.name == "duck" {
                                nodeLoc.removeFromParent()
                                self.scoreBoard()
                            }
                        }
                    }
                    for currentX in stride(from: currentX, through: currentX-50, by: -1) {
                        for currentY in stride(from: currentY, through: currentY-50, by: -1) {
                            let pX = CGFloat(currentX)
                            let pY = CGFloat(currentY)
                            let p = CGPoint(x: pX, y: pY)
                            let nodeLoc = atPoint(p)
                            if nodeLoc.name == "duck" {
                                
                                nodeLoc.removeFromParent()
                                self.scoreBoard()
                            }
                        }
                    }
                    for currentY in currentY...Int(currentY+50) {
                        for currentX in currentX...Int(currentX+50) {
                            let pX = CGFloat(currentX)
                            let pY = CGFloat(currentY)
                            let p = CGPoint(x: pX, y: pY)
                            let nodeLoc = atPoint(p)
                            if nodeLoc.name == "duck" {
                                nodeLoc.removeFromParent()
                                self.scoreBoard()
                            }
                        }
                    }
                    for currentY in stride(from: currentY, through: currentY-50, by: -1) {
                        for currentX in stride(from: currentX, through: currentX-50, by: -1) {
                            let pX = CGFloat(currentX)
                            let pY = CGFloat(currentY)
                            let p = CGPoint(x: pX, y: pY)
                            let nodeLoc = atPoint(p)
                            if nodeLoc.name == "duck" {
                                nodeLoc.removeFromParent()
                                self.scoreBoard()
                            }
                        }
                    }
                    
                    self.bomb = nil
                    shouldSpawnBomb = false
                }
            }
            
        }
        
    }
    

    func scoreBoard() {
        let oldScore = Int(viewController.score.text!)
        let newScore = oldScore! + 1
        viewController.score.text = String(newScore)
        if Int(viewController.score.text!)! % 10 == 0 && Int(viewController.score.text!) != 0 && self.bomb == nil {
            self.shouldSpawnBomb = true
        }
    }
    
    
    // 2 random functions from online 
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
   
    
    func animateDuck() {
        var textures: [SKTexture] = []
        for i in 1...3 {
            textures.append(SKTexture(imageNamed: "ghost\(i)"))
        }
        self.duckAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
    }
    
    func duckSpawn() {
        
        let duck = SKSpriteNode(imageNamed: "ghost1")
        duck.name = "duck"
        duck.size = CGSize(width: 50, height: 50)
        
        
        
        // Have to do 50 here because self.bomb.size is nil
        let randomYCord = random(min: screenSize.minY + endButton.size.height, max: screenSize.maxY - self.viewController.score.bounds.size.height)
        //let randomYCord = random(min: screenSize.minY + 50, max: screenSize.maxY - 30)
        // Want to spawn from furthest X axis but random Y axis
        duck.position = CGPoint(x: screenSize.maxX, y: randomYCord)
        
        addChild(duck)
        duck.run(SKAction.repeatForever(duckAnimation))
        // Random movement speed of the ducks
        let speed = random(min: CGFloat(4.0), max: CGFloat(8.0))
        
        // Changed to sprites go towards a random X point, however same Y as they spawned
        let movement = SKAction.move(to: CGPoint(x: 0, y: randomYCord), duration: TimeInterval(speed))
    
        
        // Remove from screen if outside
        let doneMove = SKAction.removeFromParent()
        duck.run(SKAction.sequence([movement, doneMove]))
    }
    
    
}
