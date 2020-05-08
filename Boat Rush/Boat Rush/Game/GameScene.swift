//
//  GameScene.swift
//  Boat Rush
//
//  Created by Spiro Balageorge on 2020-04-20.
//  Copyright © 2020 Spiro Balageorge. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var player: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    var coinTimer: Timer!
    var aligatorTimer: Timer!
    var coinTimeInterval: TimeInterval! = 1.5
    var aligatorTimeInterval: TimeInterval! = 3
    var scoreLabel:SKLabelNode!
    var score:Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var firstLaunch:Bool = true
    let objectCategory:UInt32 = 0x1 << 1
    let playerCategory:UInt32 = 0x1 << 0
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var aligatorAnimationDuration:TimeInterval = 7
    var coinAnimationDuration:TimeInterval = 10
    
    fileprivate func addPlayer() {
        player = SKSpriteNode(imageNamed: "raft")
        player.position = CGPoint(x: 0, y: player.size.height/2 + 20 - self.frame.size.height/2)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 100))
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = objectCategory
        player.physicsBody?.collisionBitMask = 0
        self.addChild(player)
    }
    
    fileprivate func addScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score 0")
        scoreLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - 100)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)
    }
    
    
    override func didMove(to view: SKView) {
        if firstLaunch {
        addPlayer()
        addScoreLabel()
        pauseButton = self.childNode(withName: "pauseButton") as? SKSpriteNode
        self.physicsWorld.gravity = (CGVector(dx: 0, dy: 0))
        self.physicsWorld.contactDelegate = self
        firstLaunch = false
        }
        coinTimer = Timer.scheduledTimer(timeInterval: coinTimeInterval, target: self, selector: #selector(addCoin), userInfo: nil, repeats: true)
        
        aligatorTimer = Timer.scheduledTimer(timeInterval: aligatorTimeInterval, target: self, selector: #selector(addAligator), userInfo: nil, repeats: true)
        
        
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data{
            let acceleration = accelerometerData.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
            }
        }
    }

    @objc func addCoin(){
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.name = "coin"
        coin.setScale(0.25)
        let randomX = GKRandomDistribution (lowestValue: 50 - Int(self.frame.size.width/2), highestValue: Int(self.frame.size.width/2) - 50)
        let pos = CGFloat(randomX.nextInt())
        
        coin.position = CGPoint(x: pos, y: self.frame.size.height/2 + coin.size.height)
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width/2)
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.categoryBitMask = objectCategory
        coin.physicsBody?.contactTestBitMask = playerCategory
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(coin)
        
        coinAnimationDuration = coinAnimationDuration * 0.98
        coinTimeInterval = coinTimeInterval * 1.02
        coinTimer.invalidate()
         coinTimer = Timer.scheduledTimer(timeInterval: coinTimeInterval, target: self, selector: #selector(addCoin), userInfo: nil, repeats: true)
        
        var actionArray = [SKAction]()

        actionArray.append(SKAction.move(to: CGPoint(x: pos, y: -self.frame.size.height), duration: coinAnimationDuration))
        actionArray.append(SKAction.removeFromParent())
        coin.run(SKAction.sequence(actionArray))

    }
    
    @objc func addAligator(){
           let aligator = SKSpriteNode(imageNamed: "aligator")
            aligator.name = "aligator"
           aligator.setScale(0.25)
           let randomX = GKRandomDistribution (lowestValue: 50 - Int(self.frame.size.width/2), highestValue: Int(self.frame.size.width/2) - 50)
           let pos = CGFloat(randomX.nextInt())
           
           aligator.position = CGPoint(x: pos, y: self.frame.size.height/2 + aligator.size.height)
           
           aligator.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 73, height: 120))
           aligator.physicsBody?.isDynamic = true
           aligator.physicsBody?.categoryBitMask = objectCategory
           aligator.physicsBody?.contactTestBitMask = playerCategory
           aligator.physicsBody?.collisionBitMask = 0
           aligator.physicsBody?.usesPreciseCollisionDetection = true
           self.addChild(aligator)
    
            aligatorAnimationDuration = aligatorAnimationDuration * 0.94
            aligatorTimeInterval = aligatorTimeInterval * 0.95
            aligatorTimer.invalidate()
            aligatorTimer = Timer.scheduledTimer(timeInterval: aligatorTimeInterval, target: self, selector: #selector(addAligator), userInfo: nil, repeats: true)
          
        var actionArray = [SKAction]()
           actionArray.append(SKAction.move(to: CGPoint(x: pos, y: -self.frame.size.height), duration: aligatorAnimationDuration))
           actionArray.append(SKAction.removeFromParent())
           aligator.run(SKAction.sequence(actionArray))

       }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "coin"){
            contact.bodyA.node?.removeFromParent()
            score += 10
        }
        else if (contact.bodyA.node?.name == "aligator" || contact.bodyB.node?.name == "aligator"){
            let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
            gameOverScene?.score = self.score
             let transition = SKTransition.flipVertical(withDuration: 1)
             gameOverScene?.scaleMode = .aspectFill
             scene?.view?.presentScene(gameOverScene!, transition: transition)
        }
       
        else if (contact.bodyB.node?.name == "coin"){
            contact.bodyB.node?.removeFromParent()
            score += 10
        }
    }
    
    override func didSimulatePhysics() {
        
            if  player.position.x + (xAcceleration * 50) < 50 - (self.frame.size.width/2) {
                player.position.x = 50 - self.frame.size.width/2
            }
            else if player.position.x + (xAcceleration * 50) > (self.frame.size.width/2) - 50{
                player.position.x = self.frame.size.width/2 - 50
            }
            else{
                player.position.x += xAcceleration * 50
            }
        
    }
       
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "pauseButton"{
                aligatorTimer.invalidate()
                coinTimer.invalidate()
                let pauseScene = PauseScene(fileNamed: "PauseScene")
                let transition = SKTransition.flipVertical(withDuration: 1)
                pauseScene?.gameScene = self
                pauseScene?.scaleMode = .aspectFill
                scene?.view?.presentScene(pauseScene!, transition: transition)
                   }
               }
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
}
