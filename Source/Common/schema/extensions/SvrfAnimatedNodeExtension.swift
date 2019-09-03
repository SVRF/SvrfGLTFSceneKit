//
//  SvrfAnimatedMaterialExtension.swift
//  GLTFSceneKit_macOS
//
//  Created by Roman Chaley on 8/29/19.
//

import Foundation
import SceneKit

protocol SvrfNodeAnimator {
    func animateNode(_ model: NodeAnimationModel) throws
}

struct SvrfAnimatedNodeExtension: GLTFCodable {
    struct SvrfAnimatedNodeSchema: Codable {
        let images: [Int]?
        let fps: Int?
    }
    
    let data: SvrfAnimatedNodeSchema?
    
    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        guard let node = object as? SCNNode else { return }
        guard let data = self.data else { return }
        
        let model = NodeAnimationModel()
        
        model.node = node
        model.fps = data.fps == nil ? 10 : data.fps
        
        if (data.images == nil || data.images?.count == 0) {
            print("No images were provided for the SVRF_animated_node extension")
            return
        }
        model.images = data.images
        
        do {
            try unarchiver.animateNode(model)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
