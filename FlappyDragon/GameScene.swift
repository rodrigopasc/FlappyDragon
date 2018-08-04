//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 29/07/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, Scene {
    // Define variáveis.
    var floor: Floor!
    var background: Background!
    var player: Player!
    var enemy: Enemy!
    var score: Score!
    var sound: Sound!

    var intro: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameArea: CGFloat = 410.0
    var gameStarted = false
    var gameFinished = false
    var restart = false
    var flyForce: CGFloat = 30.0
    var playerCategory: UInt32 = 1
    var enemyCategory: UInt32 = 2
    var scoreCategory: UInt32 = 4
    var velocity: Double = 110.0
    var timer: Timer!
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        floor = Floor(scene: self)
        floor.setup()
        
        background = Background(scene: self)
        background.setup()
        
        player = Player(scene: self)
        player.setup()
        
        enemy = Enemy(scene: self, player: player)
        score = Score(scene: self)
        sound = Sound(scene: self)
        
        addIntro()
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
    
    func gameOver() {
        // Para o tempo do jogo.
        timer.invalidate()
        
        // Altera as informações do elemento player.
        player.instance.zRotation = 0
        player.instance.texture = SKTexture(imageNamed: "playerDead")
        
        // Para todas as ações do jogo.
        for node in self.children {
            node.removeAllActions()
        }
        
        // Desativa a gravidade do elemento player.
        player.instance.physicsBody?.isDynamic = false
        
        // Altera os booleans de controle do jogo.
        gameFinished = true
        gameStarted = false
        
        // Aplica a tela de game over.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 40
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            self.addChild(gameOverLabel)
            self.score.show()
            self.restart = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if !gameStarted {
                // Retira a introdução.
                intro.removeFromParent()
                
                // Adiciona o label do score do player.
                self.score.setup()
                
                // Define a física do elemento.
                player.instance.physicsBody = SKPhysicsBody(circleOfRadius: player.instance.size.width / 2 - 10)
                player.instance.physicsBody?.isDynamic = true
                player.instance.physicsBody?.allowsRotation = true
                player.instance.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                player.instance.physicsBody?.categoryBitMask = playerCategory
                player.instance.physicsBody?.contactTestBitMask = scoreCategory
                player.instance.physicsBody?.collisionBitMask = enemyCategory
                
                // Define que o jogo começou.
                gameStarted = true
                
                // Adiciona os inimigos na tela.
                timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (timer) in
                    self.enemy.spawn()
                })
            } else {
                // Define a velocidade do objeto como zero. (Teríamos problema com gravidade caso não definíssemos como zero)
                player.instance.physicsBody?.velocity = CGVector.zero
                
                // Aplica o impulso quando o jogador toca na tela.
                player.instance.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
        } else {
            // Reinicia o jogo.
            if restart {
                restart = false
                gameViewController?.presentScene()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted {
            // Define a velocidade do eixo y.
            let yVelocity = player.instance.physicsBody!.velocity.dy * 0.001 as CGFloat
            
            // Aplica "animação" para o objeto rotacionar ao cair/receber impulso.
            player.instance.zRotation = yVelocity
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted {
            // Incrementa o score caso o jogador tenha passado o obstáculo ou aplica o game over.
            if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
                score.instance += 1
                scoreLabel.text = "\(score.instance)"
                self.sound.playScoreSound()
            } else if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory {
                gameOver()
                self.sound.playGameOverSound()
            }
        }
    }
}
