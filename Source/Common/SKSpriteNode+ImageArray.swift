//
//  SKSpriteNode+ImageArray.swift
//  SvrfGLTFSceneKit
//
//  Created by Jesse Boyes on 5/21/19.
//

import SpriteKit
import ImageIO

extension SKSpriteNode {

    convenience init(imageFiles: [String]) {
        guard imageFiles.count > 0 else {
            print("SKSpriteNode+ImageArray: No images provided")
            self.init()
            return
        }
        
        self.init(imageNamed: imageFiles[0])
        
        animateWithImageFiles(imageFiles)
    }
    
    convenience init(images: [UIImage]) {
        self.init(texture: SKTexture(image: images[0]))
        
        animateWithImages(images)
    }
    
    func animateWithImageFiles(_ imageFiles:[String]) {
        var currentFrame = 0
        let nextFrameAction = SKAction.run {
            self.texture = SKTexture(imageNamed: imageFiles[currentFrame])
            // Load next frame
            currentFrame += 1
            currentFrame %= imageFiles.count
        }
        let delayAction = SKAction.wait(forDuration: 0.1)
        let action = SKAction.repeatForever(SKAction.sequence([nextFrameAction, delayAction]))
        self.run(action)
    }
    
    func animateWithImages(_ images:[UIImage]) {
        let action = SKAction.repeatForever(SKAction.animate(with: images.map { return SKTexture(image: $0) },
                                                             timePerFrame: 0.1))
        self.run(action)
    }

}
