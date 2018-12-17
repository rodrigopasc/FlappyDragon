//
//  Background.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 02/08/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit

class Background {
    var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func setup() {
        // Define a Sprite com a imagem background.
        let background = SKSpriteNode(imageNamed: "background")
        
        // Define as posições do elemento.
        background.position  = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        background.zPosition = 0
        
        // Exibe na tela.
        scene.addChild(background)
    }
}
