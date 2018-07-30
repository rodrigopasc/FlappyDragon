//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Rodrigo Paschoaletto on 29/07/18.
//  Copyright © 2018 Rodrigo Paschoaletto. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    // Define as variáveis.
    var stage: SKView!
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define as informações de visualização.
        stage = view as! SKView
        stage.ignoresSiblingOrder = true
        
        // Exibe no app.
        presentScene()
        playMusic()
    }
    
    func presentScene() {
        // Aplica a tela do jogo.
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.scaleMode = .aspectFill
        scene.gameViewController = self
        stage.presentScene(scene, transition: .doorway(withDuration: 0.5))
    }
    
    func playMusic() {
        // Aplica a música de fundo.
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.1
            musicPlayer.play()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
