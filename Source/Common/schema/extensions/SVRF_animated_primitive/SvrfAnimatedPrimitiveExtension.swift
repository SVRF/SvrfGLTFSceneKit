//
//  SvrfAnimatedMaterialExtension.swift
//  GLTFSceneKit_macOS
//
//  Created by Roman Chaley on 8/29/19.
//

import Foundation
import SceneKit

protocol SvrfPrimitiveAnimator {
    func animatePrimitive(_ model: PrimitiveAnimationModel) throws
}

struct SvrfAnimatedPrimitiveExtension: GLTFCodable {
    struct SvrfAnimatedPrimitiveSchema: Codable {
        let images: [Int]?
        let fps: Int?
        
        private enum CodingKeys: String, CodingKey {
            case images
            case fps
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "SVRF_animated_primitive"
    }
    
    let data: SvrfAnimatedPrimitiveSchema?
    
    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        guard let primitive = object as? SCNNode else { return }
        guard let data = self.data else { return }
        
        let model = PrimitiveAnimationModel()

        model.fps = data.fps == nil ? 10 : data.fps

        if let material = primitive.geometry?.firstMaterial?.copy() as? SCNMaterial {
            primitive.geometry?.materials = [material]
            model.material = material
        } else {
            print("The primitive has no material")
            return
        }
        
        if (data.images == nil || data.images?.count == 0) {
            print("No images were provided for the SVRF_animated_primitive extension")
            return
        }
        model.images = data.images
        
        do {
            try unarchiver.animatePrimitive(model)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
