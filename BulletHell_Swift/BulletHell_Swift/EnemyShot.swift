//
//  EnemyShot.swift
//  BulletHell_Swift
//
//  Created by student on 4/26/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import UIKit

class EnemyShot: Projectile {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(withImage iName: String, projName pName: String) {
        super.init(withImage: iName, projName: pName)
        self.size = CGSize.init(width: 25, height: 25)
        self.physicsBody?.categoryBitMask = ENEMY_SHOT_MASK
        self.physicsBody?.collisionBitMask = PLAYER_MASK
        self.physicsBody?.contactTestBitMask = PLAYER_MASK
    }

}
