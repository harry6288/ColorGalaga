//
//  GameScene.swift
//  ColorGalaga
//
//  Created by hardeep kaur on 2019-06-24.
//  Copyright © 2019 hardeep kaur. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let screenSize = UIScreen.main.bounds.size
    var player = SKSpriteNode()
    let scoreLabel = SKLabelNode(text: "Score: ")
    let Lives = SKLabelNode(text: "Lives: ")
    

    var Bullets : [SKSpriteNode] = []
    var Enemies : [SKSpriteNode] = []
    var score = 0
    var lives = 4
    
    override func didMove(to view: SKView) {
        
        
       
        // MARK: Add a score label
        // ------------------------
        self.scoreLabel.text = "Score: \(self.score)"
        self.scoreLabel.fontName = "Avenir-Bold"
        self.scoreLabel.fontColor = UIColor.yellow
        self.scoreLabel.fontSize = 50;
        self.scoreLabel.position = CGPoint(x:-250,
                                           y:self.size.height-750)
        self.Lives.text = "Lives: \(self.lives)"
        self.Lives.fontName = "Avenir-Bold"
        self.Lives.fontColor = UIColor.yellow
        self.Lives.fontSize = 50;
        self.Lives.position = CGPoint(x:-250,
                                           y:self.size.height-800)
        addChild(self.scoreLabel)
        addChild(self.Lives)
        self.Player()
        self.Enemy()
    }
    
    // variable to keep track of how much time has passed
    var lastPosition:TimeInterval?
    
    override func update(_ currentTime: TimeInterval) {
        
        if (lastPosition == nil) {
            lastPosition = currentTime
        }
        
        let timePassed = (currentTime - lastPosition!)
        if (timePassed >= 2.5) {
            lastPosition = currentTime
            // create a bullet
            self.MakeBullet()
            self.moveEnemy()
        }
        
        
        self.CollisionDetection()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let locationTouched = touches.first else {
            return
        }
        
        let mousePosition = locationTouched.location(in: self)
        let moveAction = SKAction.moveTo(x: mousePosition.x, duration: 0.5)
        player.run(moveAction)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let locationTouched = touches.first else {
            return
        }
        
        let mousePosition = locationTouched.location(in: self)
        let moveAction = SKAction.moveTo(x: mousePosition.x, duration: 0.2)
        player.run(moveAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
     func Player(){
        player = SKSpriteNode.init(texture: SKTexture(imageNamed: "player.png"))
        player.size = CGSize.init(width: 50, height: 50)
        player.position = CGPoint.init(x: (screenSize.width/2), y: -500)
        addChild(player)
    }
    
    func Enemy(){
        
       let DifferenceBetweenEnemy : CGFloat = 15.0
        let height : CGFloat = 60.0
        let width : CGFloat = 60.0
        
        var xPosition : CGFloat = width + DifferenceBetweenEnemy
        var yPosition : CGFloat = screenSize.height - (height + DifferenceBetweenEnemy)
        
        
        for i in 0...15 {
            
            
            let enemy = SKSpriteNode.init(texture: SKTexture(imageNamed: self.EnemyImages()))
            enemy.size = CGSize.init(width: width, height: height)
            enemy.zPosition = 1
            enemy.position = CGPoint.init(x: xPosition, y: yPosition)
            addChild(enemy)
            Enemies.append(enemy)
            
            xPosition += DifferenceBetweenEnemy + width
            if xPosition >= screenSize.width - DifferenceBetweenEnemy{
                yPosition -= height + DifferenceBetweenEnemy
                xPosition = width + DifferenceBetweenEnemy
            }
        }
    }
    
    func EnemyImages() -> String{
        let Index = Int(CGFloat(arc4random_uniform(UInt32(3))))
        for Index in 0...3{
            if(Index == 0){
                return"redenemy.png"
            }
            if(Index == 1){
                return "GreenEnemy.png"
            }
            else if (Index == 2){
                return "BlueEnemy"
            }
            return "redenemy"
        }
        
        return ""
    }
    
    func MakeBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        
        // generate the position
        let bullPositionX = Int(CGFloat(player.position.x))
        let bullPositionY = Int(CGFloat(player.position.y))
        
        bullet.position = CGPoint(x:bullPositionX, y:bullPositionY)
        
        let bulletDestination = CGPoint(x: player.position.x, y: frame.size.height + bullet.frame.size.height / 2)
        self.MovingBullet(bullet: bullet, toDestination: bulletDestination,withDuration: 1.0)
        // add the bullet to  array
        self.Bullets.append(bullet)
        
    }
    
    func MovingBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval) {
        let bulletAction = SKAction.sequence([SKAction.move(to: destination, duration: duration)])
        
        bullet.run(SKAction.group([bulletAction]))
        // add the bullet
        addChild(bullet)
    }
    
    func moveEnemy(){
        if self.Enemies.count > 0{
            let enemyIndex = Int(CGFloat(arc4random_uniform(UInt32(self.Enemies.count))))
            let enemyDestination = CGPoint(x: player.position.x, y: 0.0)
            let enemyAction = SKAction.move(to: enemyDestination, duration: 1.0)
            self.Enemies[enemyIndex].run(enemyAction)
        }
    }
    
    func CollisionDetection(){
        
        for (enemyIndex, enemy) in Enemies.enumerated() {
            
            for (arrayIndex, bullet) in Bullets.enumerated() {
                
                if bullet.intersects(enemy){
                    
                    enemy.removeFromParent()
                    self.Enemies.remove(at: enemyIndex)
                    
                    bullet.removeFromParent()
                    self.Bullets.remove(at: arrayIndex)
                    //update score
                    self.score = self.score + 1
                    // 2. update the lives label
                    self.scoreLabel.text = "Score: \(self.score)"
                    if (self.score == 5) {
                        // DISPLAY THE YOU WIN SCENE
                        let winScene = WinScene(size: self.size)
                        
                        // CONFIGURE THE WIN SCENE
                        winScene.scaleMode = self.scaleMode
                        
                        // MAKE AN ANIMATION SWAPPING TO THE WIN SCENE
                        let transitionEffect = SKTransition.flipHorizontal(withDuration: 2)
                        self.view?.presentScene(winScene, transition: transitionEffect)
                        
                    }
                    
                }
                
                if (bullet.position.y >= self.size.height)  {
                    //top of screen
                    bullet.removeFromParent()
                    self.Bullets.remove(at: arrayIndex)
                }
                
            }
            
            
            if enemy.intersects(player){
                enemy.removeFromParent()
                self.Enemies.remove(at: enemyIndex)
                self.lives = self.lives - 1
                // 2. update the lives label
                self.Lives.text = "Lives: \(self.lives)"
                
                if (self.lives == 0) {
                    // DISPLAY THE YOU LOSE SCENE
                    let loseScene = GameOverScene(size: self.size)
                    
                    // CONFIGURE THE LOSE SCENE
                    loseScene.scaleMode = self.scaleMode
                    
                    // MAKE AN ANIMATION SWAPPING TO THE LOSE SCENE
                    let transitionEffect = SKTransition.flipHorizontal(withDuration: 2)
                    self.view?.presentScene(loseScene, transition: transitionEffect)
                    
                }
                
                
                
            }
            
            if (enemy.position.y <= 0.0)  {
                //Bottom of screen
                enemy.removeFromParent()
                self.Enemies.remove(at: enemyIndex)
            }
            
        }
        
        
    }
}

