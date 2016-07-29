//
//  Player.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/28/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    var playerName: String = "Typika"
    var playerIMG: SKTexture!
    
    var healthBar: HealthBar!
    var damage: CGFloat = 0
    var health: CGFloat = 500
    let totalHealth: CGFloat = 500
    
    
    init(name: String, xPos: CGFloat, yPos: CGFloat) {
        
        playerIMG = SKTexture(imageNamed: name)
        
        //SKSpriteNode's init
        super.init(texture: playerIMG, color: UIColor.clearColor(), size: playerIMG.size())
        
        // put your initializer content here
        self.playerName = name
        self.position.x = xPos
        self.position.y = yPos
        self.size.width = 75
        self.size.height = 80
        
        self.healthBar = HealthBar()
        self.addChild(healthBar)
        self.healthBar.zPosition = 0
        self.healthBar.position.x = self.size.width / -2
        self.healthBar.position.y = self.size.height - self.size.height/3
        
        self.damage = 50.0 //Player damage
        //self.healthBar.hidden = true
        
    }
    
    func dealDamage(target: Monster) {
        target.health -= self.damage
        target.healthBar.value = target.health / target.totalHealth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [PLAYER FACTORY] Returns player-character of interest. As of now only 1 character choice
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class PlayerFactory {
    static func create(player : String, xPosition: CGFloat, yPosition: CGFloat) -> Player? {
        if player == "Typika" {
            return Player(name: "Typika", xPos: xPosition, yPos: yPosition)
        }
        return nil
    }
}