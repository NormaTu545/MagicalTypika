//
//  CreditsScene.swift
//  MagicalTypika
//
//  Created by Norma Tu on 8/10/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
    
    var okButton: ButtonNode!
    var backgroundMusic: SKAudioNode!
    
    override func didMoveToView(view: SKView) {
        
        //Set up background
        let background = SKSpriteNode(imageNamed: "creditsBG")
        addChild(background)
        background.position.x = view.frame.width / 2
        background.position.y = view.frame.height / 2
        background.size = view.frame.size
        background.zPosition = -2
        
        
        //MARK: [OK Button] Brings us back to main menu
        okButton = ButtonNode(normalImageNamed: "okButton", activeImageNamed: "okButton", disabledImageNamed: "okButton")
        okButton.position.x = size.width - size.width/5
        okButton.position.y = size.height/8
        okButton.size.width = 50
        okButton.size.height = 30
        okButton.zPosition = 20
        
        addChild(okButton)
    
        okButton.selectedHandler = {
            
            if let scene = MainMenu(fileNamed:"MainMenu") {
                // Configure the view.
                let skView = self.view! as SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
            
        }
        
        if let musicURL = NSBundle.mainBundle().URLForResource("creditsBGM", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            backgroundMusic.autoplayLooped = true
            
            addChild(backgroundMusic)
        }
    }
}