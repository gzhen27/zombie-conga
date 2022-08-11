//
//  GameScene.swift
//  ZombieConga
//
//  Created by G Zhen on 8/4/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let zombieInitialPosition = CGPoint(x: 400, y: 400)
    let zombieMovePointsPerSec: CGFloat = 240.0
    let zombieRotateRadiansPerSec: CGFloat = 4.0 * π
    
    let playableRect: CGRect
    
    var diffInTime: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var velocity = CGPoint.zero
    var lastTouchLocation: CGPoint
    
    
    // MARK: - Lifecycle
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        lastTouchLocation = zombieInitialPosition
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        zombie.position = zombieInitialPosition
        addChild(zombie)
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run { [weak self] in
                self?.spawnEnemy()
            }, SKAction.wait(forDuration: 2.0)])
        ))
        
        debugDrawPlayableArea()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            diffInTime = currentTime - lastUpdateTime
        } else {
            diffInTime = 0
        }
        lastUpdateTime = currentTime
        move(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
    }

    
    // MARK: - Helper func
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(diffInTime)
        let remainingDistance = lastTouchLocation - sprite.position
        if (remainingDistance.length() <= amountToMove.length()) {
            sprite.position = lastTouchLocation
            self.velocity = CGPoint.zero
            stopZombieAnimation()
        } else {
            sprite.position += amountToMove
            rotate(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
        }
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortestAngle = shortestAngleBetween(angleA: sprite.zRotation, angelB: direction.angle)
        let rotateDuringTime = rotateRadiansPerSec * CGFloat(diffInTime)
        let amountToRotate = abs(shortestAngle) < rotateDuringTime ? abs(shortestAngle) : rotateDuringTime
        sprite.zRotation += (amountToRotate * shortestAngle.sign())
    }
    
    func moveZombieToward(location: CGPoint) {
        startZombieAnimation()
        let offset = location - zombie.position
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSec
    }

    func getZombieAnimation() -> SKAction {
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        
        textures.append(textures[2])
        textures.append(textures[1])
        
        return SKAction.animate(with: textures, timePerFrame: 0.1)
    }
    
    func startZombieAnimation() {
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(getZombieAnimation()), withKey: "animation")
        }
    }
    
    func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(
            x: size.width + enemy.size.width/2,
            y: CGFloat.random(
                min: playableRect.minY + enemy.size.height/2,
                max: playableRect.maxY + enemy.size.height/2
            )
        )
        addChild(enemy)
        
        let action = SKAction.moveTo(x: -enemy.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([action, actionRemove]))
    }
    
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
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    // MARK: - UIREsponder
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
    
    func sceneTouched(touchLocation: CGPoint) {
        lastTouchLocation = touchLocation
        moveZombieToward(location: touchLocation)
    }
}
