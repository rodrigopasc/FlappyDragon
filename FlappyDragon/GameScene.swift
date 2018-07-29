//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 29/07/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var floor: SKSpriteNode!
    var intro: SKSpriteNode!
    var player: SKSpriteNode!
    var gameArea: CGFloat = 410.0
    var velocity: Double = 100.0
    
    override func didMove(to view: SKView) {
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
    }
    
    func addBackground() {
        // Define a Sprite com a imagem background.
        let background = SKSpriteNode(imageNamed: "background")
        
        // Define as posições do elemento.
        background.position  = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        
        // Exibe na tela.
        addChild(background)
    }
    
    func addFloor() {
        // Define a Sprite com a imagem floor.
        floor = SKSpriteNode(imageNamed: "floor")
        
        // Define as posições do elemento.
        floor.position  = CGPoint(x: floor.size.width/2, y: size.height - gameArea - floor.size.height/2)
        floor.zPosition = 2
        
        // Calcula a duração da animação.
        let duration = Double(floor.size.width/2) / velocity
        
        // Animação para movimentar o chão para a direita.
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        
        // Retorna o chão ao local original.
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        
        // Array de sequência da animação.
        let sequenceAction = SKAction.sequence([moveFloorAction, resetXAction])
        
        // Repete a animação para sempre.
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        // Executa a animação.
        floor.run(repeatAction)
        
        // Exibe na tela.
        addChild(floor)
    }
    
    func addIntro() {
        // Define a Sprite com a imagem intro.
        intro = SKSpriteNode(imageNamed: "intro")
        
        // Define as posições do elemento.
        intro.position  = CGPoint(x: size.width/2, y: size.height - 210)
        intro.zPosition = 3
        
        // Exibe na tela.
        addChild(intro)
    }
    
    func addPlayer() {
        // Define a Sprite com a imagem player1.
        player = SKSpriteNode(imageNamed: "player1")
        
        // Define as posições do elemento.
        player.position  = CGPoint(x: 60, y: size.height - gameArea/2)
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
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
