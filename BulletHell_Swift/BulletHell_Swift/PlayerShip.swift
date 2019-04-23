//
//  PlayerShip.swift
//  BulletHell_Swift
//
//  Created by student on 4/19/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PlayerShip: SKSpriteNode {
    public var shooting = false
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(withImage iName: String, playerName pName: String) {
        let tex = SKTexture(imageNamed: iName)
        super.init(texture: tex, color: SKColor.clear, size: CGSize())
        self.name = pName
        self.size.height = 150
        self.size.width = 150
        self.position = CGPoint(x: self.position.x, y: -100)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PLAYER_MASK
    }
   
 }
