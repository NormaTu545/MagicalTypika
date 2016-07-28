//
//  Monster.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/26/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class Monster: SKSpriteNode { //~~~~~~~~~~~~TODO: Set up Monster class and HP Bars for both monster & player
    /* Instance variables */
    
    var monsterName: String = ""

    var health: Double = 0 //200 HP Easy, 500 HP BOSS
    //var attackSpeed: Double = 0 //Easy monster attacks faster, Boss attacks slower
    //var damageRange: Double = 0 //10 - 20 for easy monster, 20 - 25 for boss monster
    var monsterIMG: SKTexture!
    
    
    // Monster("Bubbles", textureName: "NameofPNGResource") //How to make instance
    
    init(name: String, xPos: CGFloat, yPos: CGFloat) {
        
        monsterIMG = SKTexture(imageNamed: name)
        
        //SKSpriteNode's init
        super.init(texture: monsterIMG, color: UIColor.clearColor(), size: monsterIMG.size())
        
        // put your initializer content here
        self.monsterName = name
        self.position.x = xPos
        self.position.y = yPos
        
    }
    
    func monsterAttack() {
        print("\(self.monsterName) just attacked!")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [LEVEL 1 MONSTER]
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class DaBug: Monster {
    init(name: String, xPosition: CGFloat, yPosition: CGFloat) {
        
        super.init(name: name, xPos: xPosition, yPos: yPosition)
        
        self.size.width = 40
        self.size.height = 40
        self.health = 300
        
    }
    
    override func monsterAttack() {
        print("INSERT DABUG ATTACK HERE")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [FINAL BOSS MONSTER] 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class DeeBug: Monster {
    init(name: String, xPosition: CGFloat, yPosition: CGFloat) {
        
        super.init(name: name, xPos: xPosition, yPos: yPosition)
        
        self.size.width = 100
        self.size.height = 100
        self.health = 500
        
    }
    
    override func monsterAttack() {
        print("INSERT BOSS ATTACK HERE")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [MONSTER FACTORY] Returns monster of interest
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class MonsterFactory {
    static func create(monster : String, xPosition: CGFloat, yPosition: CGFloat) -> Monster? {
        if monster == "DaBug" {
            return DaBug(name: "DaBug", xPosition: xPosition, yPosition: yPosition)
        }
        if monster == "DeeBug" {
            return DeeBug(name: "DeeBug", xPosition: xPosition, yPosition: yPosition)
        }
        return nil
    }
}

//let monster = MonsterFactory.create("DaBug")!

