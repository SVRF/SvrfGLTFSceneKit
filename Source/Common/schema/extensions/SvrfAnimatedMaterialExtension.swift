//
//  SvrfAnimatedMaterialExtension.swift
//  GLTFSceneKit_macOS
//
//  Created by Roman Chaley on 8/29/19.
//  Copyright © 2019 DarkHorse. All rights reserved.
//

import Foundation
import SceneKit

class SvrfAnimatedMaterialExtension {
    let material: SCNMaterial
    
    var currentIndex = 0
    var images: [UIImage] = []
    
    init(material: SCNMaterial) {
        self.material = material
        
        for i in 0 ... 50 {
            let fileName = String(format: "art.scnassets/textures/LD4_%05d.jpg", i)
            images.append(UIImage(named: fileName)!)
        }
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animationStep(_:)))
        displayLink.preferredFramesPerSecond = 30
        displayLink.add(to: .current, forMode: .default)
    }
    
    @objc func animationStep(_ displayLink: CADisplayLink) {
        material.diffuse.contents = images[currentIndex]
        currentIndex = (currentIndex + 1) % images.count
    }
}
