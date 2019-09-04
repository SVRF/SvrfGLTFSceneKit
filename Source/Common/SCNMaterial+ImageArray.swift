//
//  SCNMaterial+ImageArray.swift
//  GLTFSceneKit_macOS
//
//  Created by Roman Chaley on 8/30/19.
//

import SceneKit


class AnimatedMaterial {
    let defaultFps = 10

    let material: SCNMaterial
    let images: [Any]
    
    var currentIndex = 0
    
    init(material: SCNMaterial, images: [Any], fps: Int?) {
        self.material = material
        self.images = images
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animationStep(_:)))
        displayLink.preferredFramesPerSecond = fps ?? defaultFps
        displayLink.add(to: .current, forMode: .default)
    }
    
    @objc func animationStep(_ displayLink: CADisplayLink) {
        material.diffuse.contents = images[currentIndex]
        currentIndex = (currentIndex + 1) % images.count
    }
}

extension SCNMaterial {
    public func animateWithImages(images: [Any], fps: Int?) {
        let _ = AnimatedMaterial(material: self, images: images, fps: fps)
    }
}
