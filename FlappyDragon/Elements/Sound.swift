//
//  Sound.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 03/08/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit

class Sound {
    // Define variáveis.
    var scene: SKScene
    let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func playScoreSound() {
        scene.run(scoreSound)
    }
    
    func playGameOverSound() {
        scene.run(gameOverSound)
    }
}
