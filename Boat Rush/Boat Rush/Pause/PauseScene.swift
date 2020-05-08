//
//  PauseMenu.swift
//  Upstream
//
//  Created by Spiro Balageorge on 2020-04-24.
//  Copyright © 2020 Spiro Balageorge. All rights reserved.
//

import SpriteKit



class PauseScene: SKScene {
    
    
    var gameScene: GameScene!
    var resumeButton:SKSpriteNode!
    var mainMenuButton:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        resumeButton = self.childNode(withName: "resumeButton") as? SKSpriteNode
        mainMenuButton = self.childNode(withName: "mainMenuButton") as? SKSpriteNode
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "resumeButton"{
                let transition = SKTransition.flipVertical(withDuration: 1)
                transition.pausesIncomingScene = false
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
