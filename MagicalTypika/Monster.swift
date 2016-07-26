//
//  Monster.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/26/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class Monster {

    let glowBall = SKSpriteNode(imageNamed: "ball")
    
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //  [Monster Attack] Make a monster class dude. Don't leave this here
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    func monsterAttack() {
        /* Load appropriate action */
        let attack = SKAction(named: "monsterAttack")!
        
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([attack,remove])
        glowBall.hidden = false
        glowBall.runAction(sequence)
    }
}