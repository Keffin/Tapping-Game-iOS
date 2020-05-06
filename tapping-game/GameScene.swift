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




class GameScene: SKScene {
    
    // MARK: Properties
    weak var viewController: GameViewController!
    
    // This is the list of nodes displayed on the screen
    private var nodeList: [SKShapeNode] = []
    
    private var duckList: [SKNode] = []
    //private var duckCords: [CGPoint] = []
    private var bomb: SKSpriteNode? = nil //SKSpriteNode()
    private var bombList: [SKNode] = []
    //private var hasSpawnedBomb: Bool = false
    
    private var shouldSpawnBomb: Bool = false
    
    override func update(_ currentTime: TimeInterval) {
        // Change this to 10 later
        super.update(currentTime)
        
        
        if shouldSpawnBomb {
            shouldSpawnBomb = false
            self.bomb = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 20, height: 20))
            self.bomb!.name = "bomb"
            let xCord = screenSize.minX + 20
            let yCord = screenSize.minY + 20
            self.bomb!.position = CGPoint(x: xCord, y: yCord)
            // Sets bomb to be front view all the time
            self.bomb!.zPosition = 1
            addChild(self.bomb!)
        }
        
        
    }
    
    override func didMove(to view: SKView) {
        // if difficulity == easy => forDuration: 7
        // if difficulity == medium => forDuration: 5
        // if difficulity == hard => forDuration: 2
        
        
        
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(duckSpawn),
            SKAction.wait(forDuration: 1)
            ])
        ))
    }
    
    // Simple touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let w = (self.size.width + self.size.height) * 0.01
        for t in touches {
            self.nodeList.append(SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3))
            
            self.touchDown(atPoint: t.location(in: self))
            
            let location = t.location(in: self)
            let touchedNodes = nodes(at: location)
            
            
            // Checks if the touched location is a node with the property name "duck", in that case we remove it
            
            duckList = touchedNodes.filter { $0.name == "duck"}
            
            //bombList = touchedNodes.filter { $0.name == "bomb" }
            
            // Since bomb has highest z position this will always only return bomb type if bomb node is touched
            //let bombNode = atPoint(location)
            
            //let touchedNode = atPoint(location)
            
            /*if touchedNode.name == "bomb" {
                self.bomb!.position = location
                //print(self.bomb!.position)
            }*/
            
            if !duckList.isEmpty {
                self.duckList.first?.removeFromParent()
                self.scoreBoard()
            }
            
        }
    }
    
   
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.bomb != nil {
                self.bomb!.position.x = location.x
                self.bomb!.position.y = location.y
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesEnded(touches, with: event)
        //blastDucks()
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "bomb" {
                if self.bomb != nil  {
                    
                    // "Explode" after 2.0 seconds
                    self.bomb?.run(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                                      SKAction.removeFromParent()
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
                    self.bomb = nil
                }
            }
            
        }
        
    }
    

        
    
    // The scoreboard, currently TODO, want to increment score based in successful hit
    func scoreBoard() {
        let oldScore = Int(viewController.score.text!)
        let newScore = oldScore! + 1
        viewController.score.text = String(newScore)
        if Int(viewController.score.text!)! % 10 == 0 && Int(viewController.score.text!) != 0 && self.bomb == nil {
            self.shouldSpawnBomb = true
        }
    }
    
    
    // 2 random functions
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func duckSpawn() {
        
        let duck = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 40, height: 40))
        duck.name = "duck"
        
        
        // TODO: Find Duck sprite
        let randomYCord = random(min: screenSize.minY, max: screenSize.maxY)
        
        // Want to spawn from furthes X axis but random Y axis
        duck.position = CGPoint(x: screenSize.maxX, y: randomYCord)
        addChild(duck)
        
        // Random movement speed of the ducks
        let speed = random(min: CGFloat(4.0), max: CGFloat(8.0))
        
        // Changed to sprites go towards a random X point, however same Y as they spawned
        let movement = SKAction.move(to: CGPoint(x: 0, y: randomYCord), duration: TimeInterval(speed))
    
        
        // Remove from screen if outside
        let doneMove = SKAction.removeFromParent()
        duck.run(SKAction.sequence([movement, doneMove]))
    }
    
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.nodeList.first {
            n.position = pos
            //n.strokeColor = SKColor.green
            self.nodeList.first?.removeFromParent()
            self.addChild(n)
            
            
        }
        
    }
    

    
    
   
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }*/
    
    
    
    
}
