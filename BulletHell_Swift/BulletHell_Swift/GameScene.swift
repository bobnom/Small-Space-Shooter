//
//  GameScene.swift
//  BulletHell_Swift
//
//  Created by student on 4/12/18.
//  Copyright © 2018 Richland College. All rights reserved.
//

import SpriteKit
import GameplayKit

//VECTOR MATH FUNCTIONS
func Normalize(_ forNorm:CGVector) ->CGVector
{
    return CGVector.init(dx: forNorm.dx / Magnitude(forNorm), dy: forNorm.dy / Magnitude(forNorm))
}

func Magnitude(_ forMag:CGVector)->CGFloat
{
    return CGFloat(sqrt(pow(Double(forMag.dx), 2) + pow(Double(forMag.dy), 2)))
}

func Dot(_ lhs:CGVector,_ rhs:CGVector)->CGFloat
{
    return lhs.dx * rhs.dx + lhs.dy * rhs.dy
}


//Collision Masks
let PLAYER_MASK:UInt32 = 1
let ASTEROID_MASK:UInt32 = 2
let PLAYER_SHOT_MASK:UInt32 = 3
let ENEMY_SHOT_MASK:UInt32 = 4


class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var playerSprite : PlayerShip!
    let kPlayerName = "player"
    var playerControlled  = false
    var shipSpawned = false
    var gameStarted = false
    private var lastUpdateTime : TimeInterval = 0
    var gameOver = SKLabelNode(fontNamed: "Arial")
    var pressToStart = SKLabelNode(fontNamed: "Arial")
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    var backGround1 = SKSpriteNode.init(imageNamed: "Background");
    var backGround2 = SKSpriteNode.init(imageNamed: "Background");
    var score: Int = 0
        //Collision
    func didBegin(_ contact: SKPhysicsContact)
    {
        print("hit")
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if((nodeA.physicsBody?.categoryBitMask == PLAYER_MASK && nodeB.physicsBody?.categoryBitMask == ASTEROID_MASK) || (nodeB.physicsBody?.categoryBitMask == PLAYER_MASK && nodeA.physicsBody?.categoryBitMask == ASTEROID_MASK))
        {
            print("Contact 1")
            pressToStart.text = "Game Over"
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            gameStarted = false
            shipSpawned = false
            
        }
        else if ((nodeA.physicsBody?.categoryBitMask == PLAYER_SHOT_MASK && nodeB.physicsBody?.categoryBitMask == ASTEROID_MASK) || (nodeB.physicsBody?.categoryBitMask == PLAYER_SHOT_MASK && nodeA.physicsBody?.categoryBitMask == ASTEROID_MASK))
        {
            print("Contact 2")
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            nodeA.physicsBody?.categoryBitMask = 99
            nodeB.physicsBody?.categoryBitMask = 99
            score += 1
        }
        else if(nodeA.physicsBody?.categoryBitMask == ENEMY_SHOT_MASK || nodeB.physicsBody?.categoryBitMask == ENEMY_SHOT_MASK)
        {
            if(nodeA.physicsBody?.categoryBitMask == PLAYER_MASK || nodeB.physicsBody?.categoryBitMask == PLAYER_MASK)
            {
                pressToStart.text = "Game Over"
                gameStarted = false
                shipSpawned = false
                
            }
            nodeA.removeFromParent()
            nodeB.removeFromParent()
        }
        
    }

    
//Lifecycle
    
    
    
    override func sceneDidLoad() {
  
        self.lastUpdateTime = 0
        
        if !shipSpawned
        {
            backGround1.size.height = 2048
            backGround1.size.width = 1536
            backGround2.size.height = 2048
            backGround2.size.width = 1536
            backGround2.position.y = 2048
            backGround1.position.y = 0
            self.addChild(backGround1)
            self.addChild(backGround2)
            backGround1.zPosition = -10
            backGround2.zPosition = -10
            
            scoreLabel.position = CGPoint(x: -650, y: 950)
            self.addChild(scoreLabel)
            scoreLabel.zPosition = 100
            //pressToStart.position = CGPoint.init(x: 0, y: (self.view?.bounds.size.height)! / 2)
            self.addChild(pressToStart)
            pressToStart.fontSize = 100
            self.physicsWorld.contactDelegate = self
            self.physicsWorld.contactDelegate?.didBegin!(SKPhysicsContact.init())
            print(self.physicsWorld.contactDelegate as Any)
            startGame()
        }
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
           }
    
    func touchMoved(toPoint pos : CGPoint) {
           }
    
    func touchUp(atPoint pos : CGPoint) {
           }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !shipSpawned && self.children.count <= 4
        {
            startGame()
        }
        if !gameStarted
        {
            pressToStart.text = ""
        }
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        if self.nodes(at: touchLocation!).count > 0
        {
            
            for n in self.nodes(at: touchLocation!)
            {
                testForPlayer(n)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      let touch = touches.first
        if playerControlled
        {
            let moveAct = SKAction.move(to: (touch?.location(in: self))!, duration: 0.2)
            playerSprite.run(moveAct)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        playerControlled = false;
        playerSprite.shooting = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
 
    var playerCoolDown = 0.0
    var asteroidSpawnTimer = 0.0
    var alienSpawnTimer = 0.0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        //Move background
        backGround1.position.y += -100 * CGFloat(dt)
        NSLog("%f", backGround1.position.y)
        backGround2.position.y += -100 * CGFloat(dt)
        
        if backGround1.position.y + backGround1.size.height <= 0
        {
            backGround1.position.y = 2048
        }
        if backGround2.position.y + backGround1.size.height <= 0
        {
            backGround2.position.y  = 2048
        }
        
        //show score
        scoreLabel.text = "Score: " + String(score)
        
        if gameStarted
        {
            asteroidSpawnTimer += dt
            playerCoolDown += dt
            alienSpawnTimer += dt
            
            //Spawn Asteroids on a delay
            if asteroidSpawnTimer >= 1
            {
                asteroidSpawnTimer = 0.0
                let newAsteroid = Asteroid.init(withImage: "Asteroid", EnemyName: "enemy")
                let range = Int(self.size.width) * 2
                let randomX = Int(arc4random_uniform( UInt32(range))) - Int(self.size.width);
                newAsteroid.position = CGPoint.init(x: CGFloat(randomX), y: self.size.height)
                let dir = CGVector.init(dx: (playerSprite.position.x - newAsteroid.position.x) * 7, dy: (playerSprite.position.y - newAsteroid.position.y) * 7)
                self.addChild(newAsteroid)
                newAsteroid.physicsBody?.applyForce(dir)
            }
            //Spawn Aliens on a delay
            if alienSpawnTimer >= 4
            {
                alienSpawnTimer = 0.0
                let newAlien = EnemyShip.init(withImage: "Alien", EnemyName: "enemy")
                let randSelector = arc4random_uniform(100);
                //Randomly decide which side of the screen to start on
                if randSelector < 50
                {
                    newAlien.position = CGPoint.init(x: (self.view?.bounds.size.width)! - newAlien.size.width, y: (self.view?.bounds.size.height)! - newAlien.size.height)
                    
                }
                else
                {
                    newAlien.position = CGPoint.init(x: -(self.view?.bounds.size.width)! - newAlien.size.width, y: (self.view?.bounds.size.height)! - newAlien.size.height)

                }
                
                self.addChild(newAlien)
                
                //Randomly introduce some variance in the alien's trajectory
                let randDirModifier = arc4random_uniform( UInt32((self.view?.bounds.size.height)! - newAlien.size.height))
                var dir = CGVector.init(dx:Double( 0 - newAlien.position.x), dy: Double(randDirModifier) - Double(newAlien.position.y))
                dir.dx *= 10
                dir.dy *= 10
                newAlien.physicsBody?.applyForce(dir)
                
                let shootAction = SKAction.run({
                    if self.gameStarted
                    {
                        let newShot = EnemyShot.init(withImage: "AlienBullet", projName: "proj")
                        //This direction is used to create the second vector used to calculate the angle
                        //required to calculate spawn point for projectile
                        let RIGHT = CGVector.init(dx: 1, dy: 0)
                        let center = newAlien.position
                        let end = self.playerSprite.position
                        //Direction to the player
                        dir = CGVector.init(dx: end.x - center.x, dy: end.y - center.y)
                        //DIRECTION MUST BE NORMALIZED TO GET ACCURATE DOT PRODUCT
                        let dirNorm = Normalize(dir)
                        let dot = Dot(dirNorm, RIGHT)
                        //angle in rads from the direction vector towards the player to the RIGHT direction vector
                        var angle = acos(dot)
                        
                        //Because a dot product is just the cosine ration of the angle between the two vectors
                        //it cannot tell what side of the alien the player is on, thus if the player is below 
                        //the alien I have to use the opposite of the angle (this would be reversed had I flipped the 
                        //parameters for dot product)
                        if center.y > end.y
                        {
                            angle = -angle
                        }
                        //Calculate the point on an inamginary circle around the alien
                        let x = center.x + newAlien.size.width * cos(angle)
                        let y = center.y + newAlien.size.width * sin(angle)
                        newShot.position = CGPoint.init(x: x, y: y)
                        self.addChild(newShot)
                        
                        let launchForce = CGVector.init(dx: dirNorm.dx * 2000, dy: dirNorm.dy * 2000)
                        newShot.physicsBody?.applyForce(launchForce)
                        
                    }
                })
                let waitAction = SKAction.wait(forDuration: 0.75)
                let actionSeq = [shootAction,waitAction]
                
                newAlien.run(SKAction.repeatForever(SKAction.sequence(actionSeq)))
                
            }
            
        }
        else
        {
            if(self.children.count <= 4)
            {
                pressToStart.text = "Touch Screen To Restart"
            }
        }
        
        if(playerSprite.shooting && playerCoolDown >= 0.4)
        {
            playerCoolDown = 0.0
            let newShot = PlayerProj(withImage: "PlayerShot", projName: "proj")
            newShot.position.x = playerSprite.position.x
            newShot.position.y = playerSprite.position.y + playerSprite.size.height / 2 + newShot.size.height / 2
            let launch = CGVector.init(dx: 0, dy: 5000)
            self.addChild(newShot)
            newShot.physicsBody?.applyForce(launch)
        }
        let childArr = self.children
        checkOnScreenChildren(children: childArr)
        self.lastUpdateTime = currentTime
    }
    
    //HELPERS
    
    func checkOnScreenChildren(children _children:[SKNode])
    {
        for node in _children {
            if node.name == "proj"
            {
                if (node as! Projectile).isAlive && !node.intersects(node.parent!)
                {
                    node.removeFromParent()
                }
                else if !(node as! Projectile).isAlive
                {
                    (node as! Projectile).isAlive = true
                }
            }
            if node.name == "enemy"
            {
                if (node as! Enemy).isAlive && !node.intersects(node.parent!)
                {
                    node.removeFromParent()
                }
                else if !(node as! Enemy).isAlive && node.intersects(node.parent!)
                {
                    (node as! Enemy).isAlive = true
                }
            }

        }
        
    }
    
    func startGame()
    {
        pressToStart.text = "Touch Ship To Start"
        playerSprite = PlayerShip.init(withImage: "Spaceship", playerName: kPlayerName)
        shipSpawned = true
        score = 0
        addChild(playerSprite)
    }
    
    func testForPlayer(_ touchedNode: SKNode)
    {
        if touchedNode.name == kPlayerName
        {
            
            
            playerControlled = true
            playerSprite.shooting = true
            if !gameStarted
            {
                gameStarted = true
            }
        }
    }
}


