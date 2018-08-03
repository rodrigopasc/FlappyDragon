//
//  Score.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 02/08/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit

class Score {
    var scene: SKScene
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func setup() {
        // Define uma sprite label com a fonte Chalkduster.
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        // Formatação do texto do label.
        scoreLabel.fontSize = 94
        scoreLabel.text = "\(score)"
        scoreLabel.alpha = 0.8
        
        // Define as posições do elemento.
        scoreLabel.position = CGPoint(x: scene.size.width/2, y: scene.size.height - 100)
        scoreLabel.zPosition = 5
        
        // Exibe na tela.
        scene.addChild(scoreLabel)
    }
    
    
    
    func show() {
        let showScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        showScoreLabel.fontSize = 30
        showScoreLabel.text = "Score: \(score)"
        showScoreLabel.position = CGPoint(x: scene.size.width/2, y: 15)
        showScoreLabel.zPosition = 5
        scene.addChild(showScoreLabel)
    }
}
