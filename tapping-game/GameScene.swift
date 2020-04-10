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
        
        // TODO: Find Duck sprite
        let duck = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 40, height: 40))
    
        
        let randomYCord = random(min: screenSize.minY, max: screenSize.maxY)
        
        // Want to spawn from furthes X axis but random Y axis
        duck.position = CGPoint(x: screenSize.maxX, y: randomYCord)
        addChild(duck)
        
        // Random movement speed of the ducks
        let speed = random(min: CGFloat(1.0), max: CGFloat(3.0))
        
        // Currently moving them all towards origo
        let randXEnd = random(min: screenSize.minX, max: screenSize.maxX)
        // Changed to sprites go towards a random X point, however same Y as they spawned
        let movement = SKAction.move(to: CGPoint(x: randXEnd, y: randomYCord), duration: TimeInterval(speed))
        
        // Remove from screen if outside
        let doneMove = SKAction.removeFromParent()
        duck.run(SKAction.sequence([movement, doneMove]))        
    }
    
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(duckSpawn),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.nodeList.first {
            n.position = pos
            //n.strokeColor = SKColor.green
            self.nodeList.first?.removeFromParent()
            self.addChild(n)
            
            //dump(self.children)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let w = (self.size.width + self.size.height) * 0.05
        for t in touches {
            self.nodeList.append(SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3))
            self.scoreBoard()
            self.touchDown(atPoint: t.location(in: self))
        }
    }
       
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let w = (self.size.width + self.size.height) * 0.05
        for t in touches {
            self.nodeList.append(SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3))
            self.scoreBoard()
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    /*func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
            
            
        }
    }
    /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        n.position = pos
        n.strokeColor = SKColor.green
        
        self.addChild(n)
        
        //dump(self.children)
        
    }*/
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }*/
    
   
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }*/
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    /*override func didMove(to view: SKView) {
        
        
        
        // Create shape node to use during mouse interaction
        //let w = (self.size.width + self.size.height) * 0.05
        //self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        //self.nodeList.append(SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3))
        
        
        //if let spinnyNode = self.spinnyNode {
        //    spinnyNode.lineWidth = 5.0
            
            //spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), //duration: 1)))
            //spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
             //                                 SKAction.fadeOut(withDuration: 0.5),
               //                               SKAction.removeFromParent()]))
        //}
    }*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*var ball: SKShapeNode?
    private var label : SKLabelNode?
    // MARK: Init
    override init(size: CGSize) {
        super.init(size: size)
        let ball = initBall(bounds: UIScreen.main.bounds)
        addChild(ball)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func touchDown(atPoint pos: CGPoint) {
        if let n = self.ball?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
            print("TOUCH")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
       }
       
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           for t in touches { self.touchUp(atPoint: t.location(in: self)) }
       }
   
   override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       for t in touches { self.touchUp(atPoint: t.location(in: self)) }
   }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    // MARK: Methods
    func initBall(bounds: CGRect) -> SKShapeNode {
        ball = SKShapeNode(circleOfRadius: 40)
        ball.fillColor = .red
        
        let xMid = bounds.maxX / 2
        let yMid = bounds.maxY / 2
        ball.position = CGPoint(x: xMid, y: yMid)
        return ball
    }*/
    
    
}
