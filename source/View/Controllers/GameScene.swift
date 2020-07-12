//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import SpriteKit
import GameplayKit
import RxSwift
import RxRelay
import CoreMotion

enum CategoryMask: UInt32 {
    case ball = 0b01 // 1
    case shape = 0b10 // 2
    case target = 0b100
}

private let kAnimalNodeName = "movable"

class GameScene: SKScene,SKPhysicsContactDelegate {
    private var selectedNode = SKSpriteNode()
    private let background = SKSpriteNode(imageNamed: "")
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    deinit {
        print("GameScene deinited")
        
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = .clear
        
        gameBall = self.childNode(withName: "GameBall") as? SKSpriteNode
        
        let images = GameModel.ballImages
        let bg = Int(UserDefaults.standard.string(forKey: "soccer") ?? "0" )!
        gameBall.texture = SKTexture(imageNamed: images[bg])
        
        gameBall.physicsBody?.isDynamic = false
        
        gameBall.position.x = CGFloat.random(in: -150...150)
        self.setupUI()
        
        // Set the category masks
        gameBall.physicsBody?.categoryBitMask = CategoryMask.ball.rawValue
        
        // Set the collision masks
        gameBall.physicsBody?.collisionBitMask = CategoryMask.shape.rawValue | CategoryMask.target.rawValue
        
        // Set the contact masks
        gameBall.physicsBody?.contactTestBitMask = CategoryMask.shape.rawValue | CategoryMask.target.rawValue
        
    }
    
    func changeGravity(isLevelMode:Bool=false){
        if isLevelMode{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            self.setupMotionManager()
        }
        
    }
    
    var motion: CMMotionManager?
    
    func setupMotionManager(){
        
        motion = CMMotionManager()
        guard let motion = motion else{
            return
        }
        if motion.isDeviceMotionAvailable {
            
            motion.deviceMotionUpdateInterval = 0.2
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                            to: OperationQueue.main, withHandler: {
                                                (data, error) in
                                                // Make sure the data is valid before accessing it.
                                                if let validData = data {
                                                    // Get the attitude relative to the magnetic north reference frame.
                                                    let roll = validData.attitude.roll
                                                    let pitch = validData.attitude.pitch
                                                    //let yaw = validData.attitude.yaw
                                                    
                                                    //print("roll",roll,"pitch",pitch)
                                                    self.moveGameBall(pitch: pitch, roll: roll)
                                                }
            })
        }
        else{
            
        }
    }
    
    func moveGameBall(pitch:Double,roll:Double){
        
        let throttle = 0.1
        var data:Double = pitch
        data = pitch
        
        if abs(data) < throttle{
            return
        }
        
        let push:CGFloat = 2
        if pitch > 0 {
            print("push left")
            gameBall.physicsBody?.applyImpulse(CGVector(dx: -push, dy: 1))
        }
        else{
            print("push right")
            gameBall.physicsBody?.applyImpulse(CGVector(dx: push, dy: 1))
        }
        
    }
    func setupObstacles(){
        gameBall.position.x = CGFloat.random(in: -150...150)
        var x:CGFloat!
        repeat{
            x = CGFloat.random(in: -250 ... 250)
        } while( abs(x-gameBall.position.x)) < 50
        let y = CGFloat.random(in: -90 ... -50)
        targetNode.position = CGPoint(x: x, y: y)
        
        for node in self.children{
            if node.name!.contains("shape"){
                node.removeFromParent()
            }
        }
        
        var center:CGPoint!
        var rect:CGRect!
        
        for _ in 0..<6{
            let shapeID = Array(1...7).randomElement()!
            let texture = SKTexture(imageNamed: "shape\(shapeID)")
            let size = texture.size()
            repeat{
                let minX = max(-280,min(gameBall.position.x,targetNode.position.x) - 100)
                let maxX = min(280,max(gameBall.position.x,targetNode.position.x) + 100)
                let x =   CGFloat.random(in: minX ... maxX)
                let y =  CGFloat.random(in: -130 ... 80)
                center = CGPoint(x: x, y: y)
                rect = CGRect(x: x-size.width/2, y: y-size.height/2, width: size.width, height: size.height)
            }while(self.rectUsed(rect: rect))
            
            let _ = self.createShape(point: center, shapeID: shapeID)
            // node.run(SKAction.fadeIn(withDuration: 1))
        }
        
        print("finish building obstacles")
    }
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    private func rectUsed(rect:CGRect) -> Bool{
        for view in self.children where view is SKSpriteNode{
            if view.frame.intersects(rect){
                return true
            }
        }
        return false
    }
    
    func ballOutBound() -> Bool{
        return abs(gameBall.position.x) > self.size.width/2 ||  abs(gameBall.position.y) > self.size.height/2
    }
    
    private var targetNode:SKSpriteNode!
    private func setupUI(){
        
        let node = SKSpriteNode(imageNamed: "vortex")
        targetNode = node
        node.name = "vortex"
        var size =  node.texture!.size()
        var factor:CGFloat = 0.7
        if UIScreen.main.bounds.size.height == 320 || UIScreen.main.bounds.size.height == 375  {
            factor = 0.5
        }
        size = CGSize(width: size.width*factor, height:  size.height*factor)
        
        node.physicsBody = SKPhysicsBody(texture: node.texture!,
                                         size: size)
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
        
        var x:CGFloat!
        repeat{
            x = CGFloat.random(in: -250 ... 250)
        } while( abs(x-gameBall.position.x)) < 50
        let y = CGFloat.random(in: -90 ... -50)
        
        node.position = CGPoint(x: x, y: y)
        node.size = size
        
        self.addChild(node)
        
        // Set the category masks
        node.physicsBody?.categoryBitMask = CategoryMask.target.rawValue
        
        // Set the collision masks
        node.physicsBody?.collisionBitMask = ~(CategoryMask.ball.rawValue | CategoryMask.shape.rawValue)
        
        // Set the contact masks
        node.physicsBody?.contactTestBitMask = ~(CategoryMask.ball.rawValue|CategoryMask.shape.rawValue)
        
    }
    
    var gameBall:SKSpriteNode!
    func startDrop(){
        gameBall.physicsBody?.isDynamic = true
        
    }
    
    func createShape(point:CGPoint,shapeID:Int) -> SKSpriteNode{
        print("creating shape")
        let node = SKSpriteNode(imageNamed: "shape\(shapeID)")
        node.name = "shape\(shapeID)"
        var size =  node.texture!.size()
        var factor:CGFloat = 0.7
        if UIScreen.main.bounds.size.height == 320 || UIScreen.main.bounds.size.height == 375  {
            factor = 0.5
        }
        size = CGSize(width: size.width*factor, height:  size.height*factor)
        node.physicsBody = SKPhysicsBody(texture: node.texture!,
                                         size: size)
        if node.physicsBody == nil{
            node.physicsBody = SKPhysicsBody(rectangleOf: size)
        }
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
        
        node.position = point
        node.size = size
        
        self.addChild(node)
        
        // Set the category masks
        node.physicsBody?.categoryBitMask = CategoryMask.shape.rawValue
        
        // Set the collision masks
        node.physicsBody?.collisionBitMask = CategoryMask.ball.rawValue
        
        // Set the contact masks
        node.physicsBody?.contactTestBitMask = CategoryMask.ball.rawValue
        return node
        
    }
    
    var hitTarget = BehaviorRelay<Bool>(value: false)
    func didBegin(_ contact: SKPhysicsContact) {
        //print("The \(contact.bodyA.node!.name!) entered in contact with the \(contact.bodyB.node!.name!)")
        
        if contact.bodyA.node!.name! == "vortex"{
            gameBall.removeFromParent()
            hitTarget.accept(true)
        }
    }
    
    //    override func update(_ currentTime: TimeInterval) {
    //        // Called before each frame is rendered
    //    }
}
