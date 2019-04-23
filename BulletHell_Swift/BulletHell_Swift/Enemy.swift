//
//  Enemy.swift
//  BulletHell_Swift
//
//  Created by student on 4/19/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    
    var isAlive = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(withImage iName: String, EnemyName eName: String) {
        let tex = SKTexture(imageNamed: iName)
        super.init(texture: tex, color: SKColor.clear, size: CGSize())
        self.name = eName
        self.size.height = 150
        self.size.width = 150
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
       // self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
    }

}
