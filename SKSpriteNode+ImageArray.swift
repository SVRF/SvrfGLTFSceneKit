//
//  SKSpriteNode+ImageArray.swift
//  SvrfGLTFSceneKit
//
//  Created by Jesse Boyes on 5/21/19.
//

import SpriteKit
import ImageIO

extension SKSpriteNode {

    convenience init(images: [String]) {
        guard images.count > 0 else {
            print("SKSpriteNode+ImageArray: No images provided")
            self.init()
            return
        }

        self.init(imageNamed: images[0])

        animateWithImages(images)
    }
    
    func animateWithImages(_ images:[String]){
        var currentFrame = 0
        let nextFrameAction = SKAction.run {
            self.texture = SKTexture(imageNamed: images[currentFrame])
            // Load next frame
            currentFrame += 1
            currentFrame %= images.count
        }
        let delayAction = SKAction.wait(forDuration: 0.1)
        let action = SKAction.repeatForever(SKAction.sequence([nextFrameAction, delayAction]))
        self.run(action)
    }

}
