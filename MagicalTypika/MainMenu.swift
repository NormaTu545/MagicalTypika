//
//  MainMenu.swift
//  Magical Typika
//
//  Created by Norma Tu on 7/12/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

enum GameState {
    case Ready, Playing, GameOver
}

class MainMenu: SKScene {
    
    var playButton: MSButtonNode!
    //var backgroundMusic: SKAudioNode!
    
    override func didMoveToView(view: SKView) {
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        
        playButton.selectedHandler =  {
            if let scene = GameScene(fileNamed:"GameScene") {
                // Configure the view.
                let skView = self.view!
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
        
       /*
        if let musicURL = NSBundle.mainBundle().URLForResource("mainMenu", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        } */

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
}