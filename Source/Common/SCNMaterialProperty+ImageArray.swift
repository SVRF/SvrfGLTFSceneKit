//
//  SCNMaterial+ImageArray.swift
//  GLTFSceneKit_macOS
//
//  Created by Roman Chaley on 8/30/19.
//

import SceneKit

class AnimatedTexture {
    let texture: SCNMaterialProperty
    let images: [Any]

    // Todo: Add macOS support for animated textures
    #if os(iOS)
        var displayLink: CADisplayLink?
        var currentIndex = 0
    #endif
    
    init(texture: SCNMaterialProperty, images: [Any], fps: Int) {
        self.texture = texture
        self.images = images

        #if os(iOS)
            displayLink = CADisplayLink(target: self, selector: #selector(animationStep(_:)))
            displayLink!.preferredFramesPerSecond = fps
            displayLink!.add(to: .main, forMode: .default)
        #endif
    }

    #if os(iOS)
        @objc func animationStep(_ displayLink: CADisplayLink) {
            texture.contents = images[currentIndex]
            currentIndex = (currentIndex + 1) % images.count
        }

        deinit {
            displayLink!.invalidate()
        }
    #endif
}

extension SCNMaterialProperty {
    public func animateWithImages(images: [Any], fps: Int) {
        let _ = AnimatedTexture(texture: self, images: images, fps: fps)
    }
}
