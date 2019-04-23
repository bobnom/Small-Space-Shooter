//
//  PlayerShot.swift
//  BulletHell_Swift
//
//  Created by student on 4/19/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerProj: Projectile {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(withImage iName: String, projName pName: String) {
        super.init(withImage: iName, projName: pName)
        self.physicsBody?.categoryBitMask = UInt32(PLAYER_SHOT_MASK)
        self.physicsBody?.collisionBitMask = ASTEROID_MASK
    }
}
