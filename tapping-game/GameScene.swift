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
    private var bomb: SKSpriteNode? = SKSpriteNode()
    private var bombList: [SKNode] = []
    private var hasSpawnedBomb: Bool = false
    
    
    override func update(_ currentTime: TimeInterval) {
        // Change this to 10 later
        super.update(currentTime)
        
        
        if hasSpawnedBomb {
            return
        }
        if !hasSpawnedBomb && Int(viewController.score.text!)! % 5 == 0 && Int(viewController.score.text!) != 0 {
            hasSpawnedBomb = true
            bomb = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 20, height: 20))
            bomb!.name = "bomb"
            let xCord = screenSize.minX + 20
            let yCord = screenSize.minY + 20
            bomb!.position = CGPoint(x: xCord, y: yCord)
            // Sets bomb to be front view all the time
            bomb!.zPosition = 1
            addChild(bomb!)
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
            let bombNode = atPoint(location)
            
            /*if bombNode.name == "bomb" {
                self.bomb!.position = location
            }*/
            
            
            if !duckList.isEmpty {
                self.duckList.first?.removeFromParent()
                self.scoreBoard()
            }
            
        }
    }
    
    func blastDucks() {
        let xAxisScale = Int(bomb!.position.x + 25)
        let yAxisScale = Int(bomb!.position.y + 25)
        let currentX = Int(bomb!.position.x)
        let currentY = Int(bomb!.position.y)
        for ducksXAxis in currentX..<xAxisScale {
            print("X axis scale \(ducksXAxis)")
        }
        for duckYAxis in currentY..<yAxisScale {
            print("Y axis scale \(duckYAxis)")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.bomb != nil {
                bomb!.position.x = location.x
                bomb!.position.y = location.y
            }
            
            
            
            //blastDucks()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesEnded(touches, with: event)
        //blastDucks()
        if self.bomb != nil {
            print("yahooo")
            self.bomb = nil
            self.bomb?.removeFromParent()
        }
    }
    
    // Drag touch
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let w = (self.size.width + self.size.height) * 0.05
        for t in touches {
            self.nodeList.append(SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3))
            self.scoreBoard()
            self.touchDown(atPoint: t.location(in: self))
        }
    }*/

        
    
    // The scoreboard, currently TODO, want to increment score based in successful hit
    func scoreBoard() {
        let oldScore = Int(viewController.score.text!)
        let newScore = oldScore! + 1
        viewController.score.text = String(newScore)
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
