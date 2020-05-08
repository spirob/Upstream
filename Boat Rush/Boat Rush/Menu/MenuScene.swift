//
//  MenuScene.swift
//  Upstream
//
//  Created by Spiro Balageorge on 2020-04-21.
//  Copyright © 2020 Spiro Balageorge. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var playButton: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "playButton") as? SKSpriteNode
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "playButton"{
                let gameScene = GameScene(fileNamed: "GameScene")
                let transition = SKTransition.flipVertical(withDuration: 1)
                gameScene?.scaleMode = .aspectFill
                scene?.view?.presentScene(gameScene!, transition: transition)
            }
        }
    }
}

