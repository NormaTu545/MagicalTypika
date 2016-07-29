//
//  HealthBar.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/28/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar: SKSpriteNode {
    
    var bar: SKSpriteNode!
    let barSize = CGSize(width: 75, height: 10)
    
    var value: CGFloat = 1.0 {
        didSet {
            if value <= 0.0 {
                value = 0.0
            }
            bar.xScale = value
        }
    }
    
    init() {
        
        super.init(texture: nil, color: UIColor.lightGrayColor(), size: barSize)
        
        self.anchorPoint = CGPointMake(0.0, 0.0) //grey total health bar
        
        bar = SKSpriteNode(color: UIColor.init(hue: 0.95, saturation: 0.60, brightness: 1, alpha: 1), size: barSize)
        bar.anchorPoint = self.anchorPoint //red health bar
        
        self.addChild(bar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
