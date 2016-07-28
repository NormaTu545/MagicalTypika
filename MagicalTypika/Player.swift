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
    var health: Double = 0
    var playerIMG: SKTexture!
    
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