//
//  Floor.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 02/08/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit

class Floor {
    
    var scene: SKScene
    var floor: SKSpriteNode!
    var gameArea: CGFloat = 410.0
    var velocity: Double = 110.0
    var enemyCategory: UInt32 = 2
    var playerCategory: UInt32 = 1
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func setup() {
        // Define a Sprite com a imagem floor.
        floor = SKSpriteNode(imageNamed: "floor")
        
        // Define as posições do elemento.
        floor.position  = CGPoint(x: floor.size.width / 2, y: scene.size.height - gameArea - floor.size.height / 2)
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
        scene.addChild(floor)
        
        // Adiciona os limites invisíveis do cenário.
        invisibleRoof()
        invisibleFloor()
    }
    
    func invisibleFloor() {
        // Define a sprite node.
        let invisibleFloor = SKNode()
        
        // Define a física do elemento.
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: scene.size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        
        // Define as posições do elemento.
        invisibleFloor.position = CGPoint(x: scene.size.width/2, y: scene.size.height - gameArea)
        invisibleFloor.zPosition = 2
        
        // Exibe na tela.
        scene.addChild(invisibleFloor)
    }
    
    func invisibleRoof() {
        // Define a sprite node.
        let invisibleRoof = SKNode()
        
        // Define a física do elemento.
        invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: scene.size.width, height: 1))
        invisibleRoof.physicsBody?.isDynamic = false
        
        // Define as posições do elemento.
        invisibleRoof.position = CGPoint(x: scene.size.width/2, y: scene.size.height)
        invisibleRoof.zPosition = 2
        
        // Exibe na tela.
        scene.addChild(invisibleRoof)
    }
}
