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
    let zombieMovePointsPerSec: CGFloat = 240.0
    let playableRect: CGRect
    
    var diffInTime: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var velocity = CGPoint.zero
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        // backgrund node
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        // zombie node
        zombie.position = CGPoint(x: 400, y: 400)
        
        addChild(background)
        debugDrawPlayableArea()
        addChild(zombie)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            diffInTime = currentTime - lastUpdateTime
        } else {
            diffInTime = 0
        }
        lastUpdateTime = currentTime
        print("\(diffInTime*1000)")
        move(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
        rotate(sprite: zombie, direction: velocity)
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
        let amountToMove = CGPoint(x: velocity.x * CGFloat(diffInTime), y: velocity.y * CGFloat(diffInTime))
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
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
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
    
    // draw a playable rectangle to the screen
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    // make a sprite node rotate
    func rotate(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = atan2(direction.y, direction.x)
    }
}
