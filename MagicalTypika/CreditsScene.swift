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
    var firstLabel: SKLabelNode!
    var secondLabel: SKLabelNode!
    var thirdLabel: SKLabelNode!
    var fourthLabel: SKLabelNode!

    var backgroundMusic: SKAudioNode!
    
    override func didMoveToView(view: SKView) {
        
        //Set up background
        let background = SKSpriteNode(imageNamed: "creditsBG")
        addChild(background)
        background.position.x = view.frame.width / 2
        background.position.y = view.frame.height / 2
        background.size = view.frame.size
        background.zPosition = -2
        
        firstLabel = SKLabelNode(fontNamed: "Courier New Bold")
        firstLabel.fontSize = 15
        firstLabel.position.x = size.width/2
        firstLabel.position.y = size.height - (size.height/8)
        firstLabel.zPosition = 100
        firstLabel.text = "Information to be updated soon!"
        addChild(firstLabel)
        
        secondLabel = SKLabelNode(fontNamed: "Courier New Bold")
        secondLabel.fontSize = 12
        secondLabel.position.x = size.width/2
        secondLabel.position.y = firstLabel.position.y - 50
        secondLabel.zPosition = 100
        secondLabel.text = "Sound from Newgrounds Audio & Freesound.org"
        addChild(secondLabel)
        
        thirdLabel = SKLabelNode(fontNamed: "Courier New Bold")
        thirdLabel.fontSize = 12
        thirdLabel.position.x = size.width/2
        thirdLabel.position.y = secondLabel.position.y - 50
        thirdLabel.zPosition = 100
        thirdLabel.text = "Sprite Art from MapleSimulator.com"
        addChild(thirdLabel)
        
        fourthLabel = SKLabelNode(fontNamed: "Courier New Bold")
        fourthLabel.fontSize = 12
        fourthLabel.position.x = size.width/2
        fourthLabel.position.y = thirdLabel.position.y - 50
        fourthLabel.zPosition = 100
        fourthLabel.text = "All Assets used under Creative Commons"
        addChild(fourthLabel)
        
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