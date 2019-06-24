//
//  WinScene.swift
//  ColorGalaga
//
//  Created by hardeep kaur on 2019-06-24.
//  Copyright © 2019 hardeep kaur. All rights reserved.
//

import Foundation
import SpriteKit

class WinScene:SKScene {
    
    // MANDATORY CODE - JUST COPY AND PASTE
    // ---------------------------------------------
    override init(size: CGSize) {
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // YOUR CODE GOES BELOW THIS LINE
    // ---------------------------------------------
    override func didMove(to view: SKView) {
        // MARK: Create a background image:
        // --------------------------
        
        // 1. create an image node
        let bgNode = SKSpriteNode(imageNamed: "youwin")
        
        // 2. by default, image is shown in bottom left corner
        // I want to move image to middle
        // middle x: self.size.width/2
        // middle y: self.size.height/2
        bgNode.position = CGPoint(x:self.size.width/2,
                                  y:self.size.height/2)
        
        // Force the background to always appear at the back
        bgNode.zPosition = -1
        
        // Add child to the scene
        addChild(bgNode)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When user touches the screen, swap him back to the game
        let gameScene = GameScene(size: self.size)
        
        // CONFIGURE THE LOSE SCENE
        gameScene.scaleMode = self.scaleMode
        
        // MAKE AN ANIMATION SWAPPING TO THE LOSE SCENE
        let transitionEffect = SKTransition.flipVertical(withDuration: 2)
        self.view?.presentScene(gameScene, transition: transitionEffect)
    }
    
}
