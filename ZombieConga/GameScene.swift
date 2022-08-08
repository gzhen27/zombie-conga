//
//  GameScene.swift
//  ZombieConga
//
//  Created by G Zhen on 8/4/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        // backgrund node
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        // zombie node
        zombie.position = CGPoint(x: 400, y: 400)
        
        addChild(background)
        addChild(zombie)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000)")
        move(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }

    // move a sprite node with a velocity
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    // update the velocity between the zombie position and the touched position
    func moveZombieToward(location: CGPoint) {
        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        let length = CGFloat(sqrt(Double(offset.x * offset.x + offset.y * offset.y)))
        let direction = CGPoint(x: offset.x/length, y: offset.y/length)
        velocity = CGPoint(x: direction.x*zombieMovePointsPerSec, y: direction.y*zombieMovePointsPerSec)
    }
    
    // trigger the move event for a zombie
    func sceneTouched(touchLocation: CGPoint) {
        moveZombieToward(location: touchLocation)
    }
    
    // bounds a spirte node to avoid it runs off the screen
    func boundsCheckZombie() {
        let bottomLeft = CGPoint.zero
        let topRight = CGPoint(x: size.width, y: size.height)
        
        switch (zombie.position.x, zombie.position.y) {
        case let (x, _) where x <= bottomLeft.x:
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        case let (x, _) where x >= topRight.x:
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        case let (_, y) where y <= bottomLeft.y:
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        case let (_, y) where y >= topRight.y:
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        default:
            break
        }
    }
}
