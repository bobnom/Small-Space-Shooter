//
//  Asteroid.swift
//  BulletHell_Swift
//
//  Created by student on 4/19/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import UIKit

class Asteroid: Enemy {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(withImage iName: String, EnemyName pName: String) {
        super.init(withImage: iName, EnemyName: pName)
    
        self.physicsBody?.categoryBitMask = ASTEROID_MASK
        self.physicsBody?.collisionBitMask = PLAYER_MASK
        self.physicsBody?.contactTestBitMask = PLAYER_MASK
    }

}
