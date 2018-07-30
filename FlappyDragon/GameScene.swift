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
    
    // Define variáveis.
    var floor: SKSpriteNode!
    var intro: SKSpriteNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameArea: CGFloat = 410.0
    var velocity: Double = 100.0
    var gameStarted = false
    var gameFinished = false
    var restart = false
    var score: Int = 0
    static var highScore: Int = 0
    var flyForce: CGFloat = 30.0
    var playerCategory: UInt32 = 1
    var enemyCategory: UInt32 = 2
    var scoreCategory: UInt32 = 4
    var timer: Timer!
    weak var gameViewController: GameViewController?
    let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
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
        
        // Adiciona os limites invisíveis do cenário.
        invisibleRoof()
        invisibleFloor()
    }
    
    func invisibleFloor() {
        // Define a sprite node.
        let invisibleFloor = SKNode()
        
        // Define a física do elemento.
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        
        // Define as posições do elemento.
        invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea)
        invisibleFloor.zPosition = 2
        
        // Exibe na tela.
        addChild(invisibleFloor)
    }
    
    func invisibleRoof() {
        // Define a sprite node.
        let invisibleRoof = SKNode()
        
        // Define a física do elemento.
        invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleRoof.physicsBody?.isDynamic = false
        
        // Define as posições do elemento.
        invisibleRoof.position = CGPoint(x: size.width/2, y: size.height)
        invisibleRoof.zPosition = 2
        
        // Exibe na tela.
        addChild(invisibleRoof)
    }
    
    func addIntro() {
        // Define a Sprite com a imagem intro.
        intro = SKSpriteNode(imageNamed: "intro")
        
        // Define as posições do elemento.
        intro.position  = CGPoint(x: size.width/2, y: size.height - 210)
        intro.zPosition = 3
        
        // Exibe na tela.
        addChild(intro)
        
        // Exibe o high score.
        self.showHighScore()
    }
    
    func showHighScore() {
        let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.fontSize = 30
        highScoreLabel.text = "High Score: \(GameScene.highScore)"
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: 15)
        highScoreLabel.zPosition = 3
        
        if GameScene.highScore > 0 {
         addChild(highScoreLabel)
        }
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
    
    func addScore() {
        // Define uma sprite label com a fonte Chalkduster.
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        // Formatação do texto do label.
        scoreLabel.fontSize = 94
        scoreLabel.text = "\(score)"
        scoreLabel.alpha = 0.8
        
        // Define as posições do elemento.
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 100)
        scoreLabel.zPosition = 5
        
        // Exibe na tela.
        addChild(scoreLabel)
    }
    
    func spawnEnemies() {
        // Define a posição inicial do inimigo.
        let initialPosition = CGFloat(arc4random_uniform(132) + 74)
        
        // Define o número do inimigo (para carrega a imagem correta).
        let enemyNumber = Int(arc4random_uniform(4) + 1)
        
        // Define a distância do inimigo na tela.
        let enemiesDistance = self.player.size.height * 3.0
        
        // Cria os Sprite Nodes dos inimigos.
        let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemyNumber)")
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)")
        
        // Define o tamanho dos inimigos.
        let enemyWidth = enemyTop.size.width
        let enemyHeight = enemyTop.size.height
        
        // Define as posições dos elementos.
        enemyTop.position = CGPoint(x: size.width + enemyWidth/2, y: size.height - initialPosition + enemyHeight/2)
        enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemiesDistance)
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
        let distance = size.width + enemyWidth
        
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
        addChild(enemyTop)
        addChild(enemyBottom)
        addChild(laser)
    }
    
    func showScore() {
        let showScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        showScoreLabel.fontSize = 30
        showScoreLabel.text = "Score: \(score)"
        showScoreLabel.position = CGPoint(x: self.size.width/2, y: 15)
        showScoreLabel.zPosition = 5
        addChild(showScoreLabel)
    }
    
    func gameOver() {
        // Para o tempo do jogo.
        timer.invalidate()
        
        // Altera as informações do elemento player.
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "playerDead")
        
        // Para todas as ações do jogo.
        for node in self.children {
            node.removeAllActions()
        }
        
        // Desativa a gravidade do elemento player.
        player.physicsBody?.isDynamic = false
        
        // Altera os booleans de controle do jogo.
        gameFinished = true
        gameStarted = false
        
        // Verifica se é high score.
        if score > GameScene.highScore {
            GameScene.highScore = score
        }
        
        // Aplica a tela de game over.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 40
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            self.addChild(gameOverLabel)
            self.showScore()
            self.restart = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if !gameStarted {
                // Retira a introdução.
                intro.removeFromParent()
                
                // Adiciona o label do score do player.
                addScore()
                
                // Define a física do elemento.
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                player.physicsBody?.categoryBitMask = playerCategory
                player.physicsBody?.contactTestBitMask = scoreCategory
                player.physicsBody?.collisionBitMask = enemyCategory
                    
                // Define que o jogo começou.
                gameStarted = true
                
                // Adiciona os inimigos na tela.
                timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (timer) in
                    self.spawnEnemies()
                })
            } else {
                // Define a velocidade do objeto como zero. (Teríamos problema com gravidade caso não definíssemos como zero)
                player.physicsBody?.velocity = CGVector.zero
                
                // Aplica o impulso quando o jogador toca na tela.
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
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
            let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat
            
            // Aplica "animação" para o objeto rotacionar ao cair/receber impulso.
            player.zRotation = yVelocity
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted {
            // Incrementa o score caso o jogador tenha passado o obstáculo ou aplica o game over.
            if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
                score += 1
                scoreLabel.text = "\(score)"
                run(scoreSound)
            } else if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory {
                gameOver()
                run(gameOverSound)
            }
        }
    }
}
