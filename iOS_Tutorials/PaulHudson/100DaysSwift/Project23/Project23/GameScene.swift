//
//  GameScene.swift
//  Project23
//
//  Created by Michael Brockman on 11/17/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum SequenceType: CaseIterable {
  case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

enum ForceBomb {
  case never, always, random
}

enum K {
  
  //dimensions/positions
  static let width = 1024
  static let height = 768
  static let fastEnemyVelocityModifier = 2
  
  //stringly typed
  static let bomb = "bomb"
  static let bombContainer = "bombContainer"
  static let defaultFont = "Chalkduster"
  static let enemy = "enemy"
  static let fastEnemy = "fastEnemy"
  static let gameOver = "gameOver"
  static let penguin = "penguin"
  static let sliceBG = "sliceBackground"
  static let sliceBomb = "sliceBomb"
  static let sliceBombFuse = "sliceBombFuse"
  static let sliceFuse = "sliceFuse"
  static let sliceHitEnemy = "sliceHitEnemy"
  static let sliceHitBomb = "sliceHitBomb"
  static let sliceLife = "sliceLife"
  static let sliceLifeGone = "sliceLifeGone"
  
  struct Sounds {
    static let explosion = "explosion.caf"
    static let launch = "launch.caf"
    static let whack = "whack.caf"
    static let wrong = "wrong.caf"
  }
  
  
}

class GameScene: SKScene {

  var gameScore: SKLabelNode!
  var bombSoundEffect: AVAudioPlayer?
  
  var activeEnemies = [SKSpriteNode]()
  var activeSlicePoints = [CGPoint]()
  var sequence = [SequenceType]()
  
  var isGameEnded = false
  var isSwooshSoundActive = false
  var nextSequenceQueued = true
  
  var sequencePosition = 0
  
  var popupTime = 0.9
  var chainDelay = 3.0
  
  
  var score = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }
  
  var livesImages = [SKSpriteNode]()
  var lives = 3
  
  var activeSliceBG: SKShapeNode!
  var activeSliceFG: SKShapeNode!
  private var label : SKLabelNode?
  private var spinnyNode : SKShapeNode?
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: K.sliceBG)
    background.position = CGPoint(x: K.width / 2, y: K.height / 2) //original x = 512
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    physicsWorld.gravity = CGVector(dx: 0, dy: -6)
    physicsWorld.speed = 0.85 //negative or positive?
    
    createScore()
    createLives()
    createSlices()
    
    sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]

    for _ in 0 ... 1000 {
      if let nextSequence = SequenceType.allCases.randomElement() {
        sequence.append(nextSequence)
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
    { [weak self] in
      self?.tossEnemies()
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    
    if isGameEnded {
      
    }
    
    if activeEnemies.count > 0 {
      for (index, node) in activeEnemies.enumerated().reversed() {
        if node.position.y < -140 {
          node.removeAllActions()
          
          if node.name == K.enemy {
            node.name = ""
            subtractLife()
            
            node.removeFromParent()
            activeEnemies.remove(at: index)
          } else if node.name == K.bombContainer {
            node.name = ""
            node.removeFromParent()
            activeEnemies.remove(at: index)
          }
        }
      }
    } else {
      if !nextSequenceQueued {
        DispatchQueue.main.asyncAfter(deadline: .now() + popupTime)
        { [weak self] in
          self?.tossEnemies()
        }
        nextSequenceQueued = true
      }
    }
    
    var bombCount = 0
    
    for node in activeEnemies {
      if node.name == K.bombContainer {
        bombCount += 1
        break
      }
    }
    
    if bombCount == 0 {
      bombSoundEffect?.stop()
      bombSoundEffect = nil
    }
  }
  
  func createScore() {
    gameScore = SKLabelNode(fontNamed: K.defaultFont)
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    addChild(gameScore)
    
    gameScore.position = CGPoint(x: 8, y: 40)
    score = 0
  }
  
  func createLives() {
    for i in 0 ..< 3 {
      let spriteNode = SKSpriteNode(imageNamed: K.sliceLife)
      spriteNode.position = CGPoint(x: CGFloat(K.width + (i * 70) - 180), y: CGFloat(K.height - 50))//ipad: 834 + (i * 70) and y 700
      addChild(spriteNode)
      
      livesImages.append(spriteNode)
    }
  }
  
  func createSlices() {
    activeSliceBG = SKShapeNode()
    activeSliceBG.zPosition = 2
    activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
    activeSliceBG.lineWidth = 9
    
    activeSliceFG = SKShapeNode()
    activeSliceFG.zPosition = 3
    activeSliceFG.strokeColor = .white
    activeSliceFG.lineWidth = 5
    
    addChild(activeSliceBG)
    addChild(activeSliceFG)
  }
  
  func redrawActiveSlice() {
//1    If we have fewer than two points in our array, we don't have enough data to draw a line so it needs to clear the shapes and exit the method.
    if activeSlicePoints.count < 2 {
      activeSliceBG.path = nil
      activeSliceFG.path = nil
      return
    }
  
//2    If we have more than 12 slice points in our array, we need to remove the oldest ones until we have at most 12 – this stops the swipe shapes from becoming too long.
    if activeSlicePoints.count > 12 {
      activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
    }
//3    It needs to start its line at the position of the first swipe point, then go through each of the others drawing lines to each point.
    let path = UIBezierPath()
    path.move(to: activeSlicePoints[0])
    
    for i in 1 ..< activeSlicePoints.count {
      path.addLine(to: activeSlicePoints[i])
    }
    
//4    Finally, it needs to update the slice shape paths so they get drawn using their designs – i.e., line width and color.
    activeSliceBG.path = path.cgPath
    activeSliceFG.path = path.cgPath
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
      n.position = pos
      n.strokeColor = SKColor.green
      self.addChild(n)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    
    activeSlicePoints.removeAll(keepingCapacity: true)
    
    let location = touch.location(in: self)
    activeSlicePoints.append(location)
    
    redrawActiveSlice()
    activeSliceBG.removeAllActions()
    activeSliceFG.removeAllActions()
    activeSliceBG.alpha = 1
    activeSliceFG.alpha = 1
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isGameEnded { return }
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    activeSlicePoints.append(location)
    redrawActiveSlice()
    
    let nodesAtPoint = nodes(at: location)
    
    for case let node as SKSpriteNode in nodesAtPoint {
      if node.name == "enemy" {
        if let emitter = SKEmitterNode(fileNamed: K.sliceHitEnemy) {
          emitter.position = node.position
          addChild(emitter)
        }
        
        node.name = ""
        
        node.physicsBody?.isDynamic = false
        
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        
        let seq = SKAction.sequence([group, .removeFromParent()])
        node.run(seq)

        score += 1
        
        if let index = activeEnemies.firstIndex(of: node) {
          activeEnemies.remove(at: index)
        }
        
        run(SKAction.playSoundFileNamed(K.Sounds.whack, waitForCompletion: false))
      } else if node.name == K.fastEnemy {
        if let emitter = SKEmitterNode(fileNamed: K.sliceHitEnemy) {
          emitter.position = node.position
          addChild(emitter)
        }
        
        node.name = ""
        
        node.physicsBody?.isDynamic = false
        
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        
        let seq = SKAction.sequence([group, .removeFromParent()])
        node.run(seq)
        
        score += 2
        
        if let index = activeEnemies.firstIndex(of: node) {
          activeEnemies.remove(at: index)
        }
        
        run(SKAction.playSoundFileNamed(K.Sounds.whack, waitForCompletion: false))
        
      } else if node.name == K.bomb {
        
        guard let bombContainer = node.parent as? SKSpriteNode else { continue }
        
        if let emitter = SKEmitterNode(fileNamed: K.sliceHitBomb) {
          emitter.position = bombContainer.position
          addChild(emitter)
        }
        
        node.name = ""
        bombContainer.physicsBody?.isDynamic = false
        
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        
        let seq = SKAction.sequence([group, .removeFromParent()])
        bombContainer.run(seq)
        
        if let index = activeEnemies.firstIndex(of: bombContainer) {
          activeEnemies.remove(at: index)
        }
        
        run(SKAction.playSoundFileNamed(K.Sounds.explosion, waitForCompletion: false))
        endGame(triggeredByBomb: true)
        
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
    activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
      n.position = pos
      n.strokeColor = SKColor.blue
      self.addChild(n)
    }
    
    if !isSwooshSoundActive {
      playSwooshSound()
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
      n.position = pos
      n.strokeColor = SKColor.red
      self.addChild(n)
    }
  }
  
  
  //MARK: custom functions
  func playSwooshSound() {
    isSwooshSoundActive = true
    
    let randomNumber = Int.random(in: 1...3)
    let soundName = "swoosh\(randomNumber).caf"
    
    let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
    
    run(swooshSound) { [weak self] in
      self?.isSwooshSoundActive = false
    }
  }
  
  func createEnemy(forceBomb: ForceBomb = .random) {
    let enemy: SKSpriteNode
    
    var enemyType = Int.random(in: 0...6)
    
    if forceBomb == .never {
      enemyType = 1
    } else if forceBomb == .always {
      enemyType = 0
    }
    
    if enemyType == 0 {

//1      Create a new SKSpriteNode that will hold the fuse and the bomb image as children, setting its Z position to be 1.
      enemy = SKSpriteNode()
      enemy.zPosition = 1
      enemy.name = K.bombContainer
//2      Create the bomb image, name it "bomb", and add it to the container.
      let bombImage = SKSpriteNode(imageNamed: K.sliceBomb)
      bombImage.name = K.bomb
      enemy.addChild(bombImage)
//3      If the bomb fuse sound effect is playing, stop it and destroy it.
      if bombSoundEffect != nil {
        bombSoundEffect?.stop()
        bombSoundEffect = nil
      }
//4      Create a new bomb fuse sound effect, then play it.
      if let path = Bundle.main.url(forResource: K.sliceBombFuse, withExtension: "") {
        if let sound = try? AVAudioPlayer(contentsOf: path) {
          bombSoundEffect = sound
          sound.play()
        }
      }
//5      Create a particle emitter node, position it so that it's at the end of the bomb image's fuse, and add it to the container.
      if let emitter = SKEmitterNode(fileNamed: K.sliceFuse) {
        emitter.position = CGPoint(x: 76, y: 64)
        enemy.addChild(emitter)
      }
      
    } else if enemyType == 6 {
      enemy = SKSpriteNode(imageNamed: K.penguin)
      run(SKAction.playSoundFileNamed(K.Sounds.launch, waitForCompletion: false))
      enemy.name = K.fastEnemy
    } else {
      enemy = SKSpriteNode(imageNamed: K.penguin)
      run(SKAction.playSoundFileNamed(K.Sounds.launch, waitForCompletion: false))
      enemy.name = K.enemy
    }
    
    //pos code goes here
    let randomPosition = CGPoint(x: Int.random(in: 64...K.width / 2), y: -128) //original top end x is 960
    enemy.position = randomPosition
    
    let randomAngularVelocity = CGFloat.random(in: -3...3)
    let randomXVelocity: Int
    
    switch randomPosition.x {
    case 0...256: //0...256
      randomXVelocity = Int.random(in: 8...15)
    case 257...512: //257...512
      randomXVelocity = Int.random(in: 3...15)
    case 513...768: //513...768
      randomXVelocity = -Int.random(in: 3...15)
    default:
      randomXVelocity = -Int.random(in: 8...15)
    }
    
    let randomYVelocity = Int.random(in: 24...32)
    
    enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
    enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
    if enemy.name == K.fastEnemy { enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40 * K.fastEnemyVelocityModifier, dy: randomYVelocity * 40 * K.fastEnemyVelocityModifier)}
    enemy.physicsBody?.angularVelocity = randomAngularVelocity
    enemy.physicsBody?.collisionBitMask = 0
      
    addChild(enemy)
    activeEnemies.append(enemy)
    
  }
  
  func tossEnemies() {
    if isGameEnded {
      
      let gameOverNode = SKSpriteNode(imageNamed: K.gameOver)
      gameOverNode.position = CGPoint(x: K.width / 2, y: K.height / 2)
      addChild(gameOverNode)
      
      return
    }
    
    popupTime *= 0.991
    chainDelay *= 0.99
    physicsWorld.speed *= 1.02
    
    let sequenceType = sequence[sequencePosition]
    
    switch sequenceType {
    case .oneNoBomb:
      createEnemy(forceBomb: .never)
      
    case .one:
      createEnemy()
      
    case .twoWithOneBomb:
      createEnemy(forceBomb: .never)
      createEnemy(forceBomb: .always)
      
    case .two:
      createEnemy()
      createEnemy()
      
    case .three:
      createEnemy()
      createEnemy()
      createEnemy()
      
    case .four:
      createEnemy()
      createEnemy()
      createEnemy()
      createEnemy()
      
    case .chain:
      createEnemy()
      
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 5.0))
      { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 5.0 * 2))
      { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 5.0 * 3))
      { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 5.0 * 4))
      { [weak self] in self?.createEnemy() }
      
    case .fastChain:
      createEnemy()
      
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 10.0))
      { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 10.0 * 2))
      { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 10.0 * 3))
      { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(
        deadline: .now() + (chainDelay / 10.0 * 4))
      { [weak self] in self?.createEnemy() }
       
    }
    
    sequencePosition += 1
    nextSequenceQueued = false
  }
  
  func subtractLife() {
    lives -= 1
    
    run(SKAction.playSoundFileNamed(K.Sounds.wrong, waitForCompletion: false))
    
    var life: SKSpriteNode
    
    if lives == 2 {
      life = livesImages[0]
    } else if lives == 1 {
      life = livesImages[1]
    } else {
      life = livesImages[2]
      endGame(triggeredByBomb: false)
    }
    
    life.texture = SKTexture(imageNamed: K.sliceLifeGone)
    
    life.xScale = 1.3
    life.yScale = 1.3
    life.run(SKAction.scale(to: 1, duration: 0.1))
  }
  
  func endGame(triggeredByBomb: Bool) {
    if isGameEnded {
      return
    }
    
    isGameEnded = true
    physicsWorld.speed = 0
    isUserInteractionEnabled = false
    
    bombSoundEffect?.stop()
    bombSoundEffect = nil
    
    if triggeredByBomb {
      livesImages[0].texture = SKTexture(imageNamed: K.sliceLifeGone)
      livesImages[1].texture = SKTexture(imageNamed: K.sliceLifeGone)
      livesImages[2].texture = SKTexture(imageNamed: K.sliceLifeGone)
    }
  }
  
}
