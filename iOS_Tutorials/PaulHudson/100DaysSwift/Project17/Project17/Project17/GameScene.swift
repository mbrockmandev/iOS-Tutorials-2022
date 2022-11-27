  //
  //  GameScene.swift
  //  Project17
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  var starfield: SKEmitterNode!
  var player: SKSpriteNode!
  var enemyCount: Int = 0
  var timerInterval: Double = 1.0
  
  var scoreLabel: SKLabelNode!
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  let possibleEnemies = ["ball", "hammer", "tv"]
  var isGameOver = false
  var gameTimer: Timer?
  
  
  private var label : SKLabelNode?
  private var spinnyNode : SKShapeNode?
  
  func didBegin(_ contact: SKPhysicsContact) {
    let explosion = SKEmitterNode(fileNamed: "explosion")!
    explosion.position = player.position
    addChild(explosion)
    
    player.removeFromParent()
    
    isGameOver = true
  }
  
  override func didMove(to view: SKView) {
    backgroundColor = .black
    
    starfield = SKEmitterNode(fileNamed: "starfield")!
    starfield.position = CGPoint(x: 1024, y: 384)
    starfield.advanceSimulationTime(10)
    addChild(starfield)
    starfield.zPosition = -1
    
    player = SKSpriteNode(imageNamed: "player")
    player.position = CGPoint(x: 100, y: 384)
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    player.physicsBody?.contactTestBitMask = 1
    addChild(player)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.horizontalAlignmentMode = .left
    addChild(scoreLabel)
    
    score = 0
    
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    physicsWorld.contactDelegate = self
    
    if enemyCount % 20 == 0 {
      gameTimer?.invalidate()
      timerInterval -= 0.1
    }
    
    gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
  }
  
  @objc func createEnemy() {
    guard let enemy = possibleEnemies.randomElement() else { return }
    
    if !isGameOver {
      let sprite = SKSpriteNode(imageNamed: enemy)
      sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
      addChild(sprite)
      enemyCount += 1
      
      sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
      sprite.physicsBody?.categoryBitMask = 1
      sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
      sprite.physicsBody?.angularVelocity = 5
      sprite.physicsBody?.linearDamping = 0
      sprite.physicsBody?.angularDamping = 0
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    guard let touch = touches.first else { return }
//    var location = touch.location(in: self)
//
//    let deltaY = location.y - player.position.y
//    let deltaX = location.x - player.position.x
//
//    if deltaY < 1 && deltaX < 1 {
//      player.position = location
//    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    let absoluteY = abs(location.y - player.position.y)
    let absoluteX = abs(location.x - player.position.x)
    print(">>> absoluteY = \(absoluteY)")
    print(">>> absoluteX = \(absoluteX)")
    let overallAbsolute = absoluteY + absoluteX
        
    if overallAbsolute < 2 {
      player.position = location
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    var location = touch.location(in: self)
    
    if location.y < 100 {
      location.y = 100
    } else if location.y > 668 {
      location.y = 668
    }
    player.position = location
  }
  
  override func update(_ currentTime: TimeInterval) {
    for node in children {
      if node.position.x < -300 {
        node.removeFromParent()
      }
    }
    
    if !isGameOver {
      score += 1
    } else {
      print("Final score was: \(score)")
      
    }
  }
  

  
}
