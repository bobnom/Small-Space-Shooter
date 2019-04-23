//
//  Projectile.swift
//  BulletHell_Swift
//
//  Created by student on 4/19/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import UIKit
import SpriteKit

class Projectile: SKSpriteNode {
    public var isAlive = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(withImage iName: String, projName pName: String) {
        let tex = SKTexture(imageNamed: iName)
        super.init(texture: tex, color: SKColor.clear, size: CGSize())
        self.name = pName
        self.size.height = 50
        self.size.width = 25
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
    }

}
