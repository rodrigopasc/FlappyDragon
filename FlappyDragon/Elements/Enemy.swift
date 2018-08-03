//
//  Enemy.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 02/08/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit

class Enemy {
    
    var scene: SKScene
    var player: Player
    
    var playerCategory: UInt32 = 1
    var enemyCategory: UInt32 = 2
    var scoreCategory: UInt32 = 4
    
    var velocity: Double = 110.0
    
    init(scene: SKScene, player: Player) {
        self.scene = scene
        self.player = player
    }
    
    func spawn() {
        // Define a posição inicial do inimigo.
        let initialPosition = CGFloat(arc4random_uniform(132) + 74)
        
        // Define o número do inimigo (para carrega a imagem correta).
        let enemyNumber = Int(arc4random_uniform(4) + 1)
        
        // Define a distância do inimigo na tela.
        let enemiesDistance = player.player.size.height * 2.5
        
        // Cria os Sprite Nodes dos inimigos.
        let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemyNumber)")
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)")
        
        // Define o tamanho dos inimigos.
        let enemyWidth = enemyTop.size.width
        let enemyHeight = enemyTop.size.height
        
        // Define as posições dos elementos.
        enemyTop.position = CGPoint(x: scene.size.width + enemyWidth/2, y: scene.size.height - initialPosition + enemyHeight/2)
        enemyBottom.position = CGPoint(x: scene.size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemiesDistance)
        enemyTop.zPosition = 1
        enemyBottom.zPosition = 1
        
        // Aplica a física aos elementos.
        enemyTop.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
        enemyTop.physicsBody?.isDynamic = false
        enemyTop.physicsBody?.categoryBitMask = enemyCategory
        enemyTop.physicsBody?.contactTestBitMask = playerCategory
        enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyBottom.size)
        enemyBottom.physicsBody?.isDynamic = false
        enemyBottom.physicsBody?.categoryBitMask = enemyCategory
        enemyBottom.physicsBody?.contactTestBitMask = playerCategory
        
        // Define o laser e sua física.
        let laser = SKNode()
        laser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height/2 - enemiesDistance/2)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemiesDistance))
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.categoryBitMask = scoreCategory
        
        // Define a distância do elemento.
        let distance = scene.size.width + enemyWidth
        
        // Define a duração do elemento.
        let duration = Double(distance)/velocity
        
        // Inicia a animação do elemento.
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        
        // Retira o elemento da tela.
        let removeAction = SKAction.removeFromParent()
        
        // Array de sequência da animação.
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        // Executa a animação.
        enemyTop.run(sequenceAction)
        enemyBottom.run(sequenceAction)
        laser.run(sequenceAction)
        
        // Exibe na tela.
        scene.addChild(enemyTop)
        scene.addChild(enemyBottom)
        scene.addChild(laser)
    }
}
