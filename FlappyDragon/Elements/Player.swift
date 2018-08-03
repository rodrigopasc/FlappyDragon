//
//  Player.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 02/08/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit

class Player {
    var scene: SKScene
    var player: SKSpriteNode!
    var gameArea: CGFloat = 410.0
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func setup() {
        // Define a Sprite com a imagem player1.
        player = SKSpriteNode(imageNamed: "player1")
        
        // Define as posições do elemento.
        player.position  = CGPoint(x: 60, y: scene.size.height - gameArea / 2)
        player.zPosition = 4
        
        // Define o array de texturas do player.
        var playerTextures = [SKTexture]()
        
        // Alimenta o array com as quatro texturas do player.
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        
        // Faz a animação com o array de texturas tendo duração de 0.009s por frame.
        let animationAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09)
        
        // Repete a animação para sempre.
        let repeatAction = SKAction.repeatForever(animationAction)
        
        // Executa a animação.
        player.run(repeatAction)
        
        // Exibe na tela.
        scene.addChild(player)
    }
}
