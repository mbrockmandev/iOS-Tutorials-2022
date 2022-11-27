  //
  //  GameScene.swift
  //  Project11
  //
  //  Created by Michael Brockman on 9/13/22.
  //

import SpriteKit


class GameScene: SKScene {
  
  var scoreLabel: SKLabelNode!
  var editLabel: SKLabelNode!
  var ballCount: Int = 0
  
  var editingMode: Bool = false {
    didSet {
      if editingMode {
        editLabel.text = "Done"
      } else {
        editLabel.text = "Edit"
      }
    }
  }
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score \(score)"
    }
  }
  
  
  override func didMove(to view: SKView) {
    
    physicsWorld.contactDelegate = self
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    let line = SKSpriteNode(color: .lightGray, size: CGSize(width: 2500, height: 2))
    line.alpha = 0.2
    line.position = CGPoint(x: 0, y: 500)
    line.blendMode = .replace
    line.zPosition = -0.5
    addChild(line)
    
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

    makeSlot(at: CGPoint(x: 128, y: 50), isGood: true)
    makeSlot(at: CGPoint(x: 384, y: 50), isGood: false)
    makeSlot(at: CGPoint(x: 640, y: 50), isGood: true)
    makeSlot(at: CGPoint(x: 896, y: 50), isGood: false)
    
    makeBouncer(at: CGPoint(x: 0, y: 50))
    makeBouncer(at: CGPoint(x: 256, y: 50))
    makeBouncer(at: CGPoint(x: 512, y: 50))
    makeBouncer(at: CGPoint(x: 768, y: 50))
    makeBouncer(at: CGPoint(x: 1024, y: 50))
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.position = CGPoint(x: 980, y: 650)
    addChild(scoreLabel)
    
    editLabel = SKLabelNode(fontNamed: "Chalkduster")
    editLabel.text = "Edit"
    editLabel.position = CGPoint(x: 80, y: 650)
    addChild(editLabel)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let objects = nodes(at: location)
    
    if objects.contains(editLabel) {
      editingMode.toggle()
    } else {
      if editingMode {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        
        addChild(box)
      } else {
      
        if ballCount < 5 {
          let ballColor = BallColor.allCases.randomElement()?.rawValue ?? "ballRed"
          let ball = SKSpriteNode(imageNamed: ballColor)
          ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
          ball.physicsBody?.restitution = 0.4
          ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
          if location.y < 500 {
            return
          } else {
            ball.position = location
            ball.name = "ball"
            addChild(ball)
            ballCount += 1
          }
        }
      }
    }
  }
  
  func makeBouncer(at position: CGPoint) {
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
    bouncer.physicsBody?.isDynamic = false
    addChild(bouncer)
  }
  
  func makeSlot(at position: CGPoint, isGood: Bool) {
    var slotBase: SKSpriteNode
    var slotGlow: SKSpriteNode
    
    if isGood {
      slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
      slotBase.name = "good"
    } else {
      slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
      slotBase.name = "bad"
    }
    
    slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
    slotBase.physicsBody?.isDynamic = false
    
    slotBase.position = position
    slotGlow.position = position
    addChild(slotBase)
    addChild(slotGlow)
    
    let spin = SKAction.rotate(byAngle: .pi, duration: 20)
    let spinForever = SKAction.repeatForever(spin)
    slotGlow.run(spinForever)
    
  }
  
  
  
}

extension GameScene: SKPhysicsContactDelegate {
  
  func collisionBetween(ball: SKNode, object: SKNode) {
    if object.name == "box" {
      destroy(node: object)
    }
    if object.name == "good" {
      score += 1
      ballCount -= 1
      destroy(node: ball)
    } else if object.name == "bad" {
      if score >= 1 {
        score -= 1
      }
      destroy(node: ball)
    }
  }
  
  func destroy(node: SKNode) {
    guard let fireParticles = SKEmitterNode(fileNamed: "MyParticle") else { return }
    fireParticles.position = node.position
    addChild(fireParticles)
    node.removeFromParent()
    ballCount -= 1

  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if nodeA.name == "ball" {
      collisionBetween(ball: nodeA, object: nodeB)
    } else if nodeB.name == "ball" {
      collisionBetween(ball: nodeB, object: nodeA)
    }
    
  }
  
}
