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
    
    var displayLink: CADisplayLink?
    var currentIndex = 0
    
    init(texture: SCNMaterialProperty, images: [Any], fps: Int) {
        self.texture = texture
        self.images = images

        displayLink = CADisplayLink(target: self, selector: #selector(animationStep(_:)))
        displayLink!.preferredFramesPerSecond = fps
        displayLink!.add(to: .current, forMode: .default)
    }
    
    @objc func animationStep(_ displayLink: CADisplayLink) {
        texture.contents = images[currentIndex]
        currentIndex = (currentIndex + 1) % images.count
    }
    
    deinit {
        displayLink!.remove(from: .current, forMode: .default)
    }
}

extension SCNMaterialProperty {
    public func animateWithImages(images: [Any], fps: Int) {
        let _ = AnimatedTexture(texture: self, images: images, fps: fps)
    }
}
