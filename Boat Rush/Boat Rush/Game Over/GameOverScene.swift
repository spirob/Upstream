//
//  GameOverScene.swift
//  Upstream
//
//  Created by Spiro Balageorge on 2020-04-22.
//  Copyright © 2020 Spiro Balageorge. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var tryAgainButton: SKSpriteNode!
    var mainMenuButton: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score:Int = 0
    
    override func didMove(to view: SKView) {
        tryAgainButton = self.childNode(withName: "tryAgainButton") as? SKSpriteNode
        mainMenuButton = self.childNode(withName: "mainMenuButton") as? SKSpriteNode
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "Score: \(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "tryAgainButton"{
               let gameScene = GameScene(fileNamed: "GameScene")
               let transition = SKTransition.flipVertical(withDuration: 1)
               gameScene?.scaleMode = .aspectFill
               scene?.view?.presentScene(gameScene!, transition: transition)
            }
            else if nodesArray.first?.name == "mainMenuButton"{
               let menuScene = MenuScene(fileNamed: "MenuScene")
                let transition = SKTransition.flipVertical(withDuration: 1)
                menuScene?.scaleMode = .aspectFill
                scene?.view?.presentScene(menuScene!, transition: transition)
            }
        }
    }

}
