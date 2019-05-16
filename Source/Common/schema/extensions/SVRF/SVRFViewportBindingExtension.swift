//
//  SVRFViewportBinding.swift
//  SvrfGLTFSceneKit
//
//  Created by Jesse Boyes on 5/15/19.
//

import Foundation
import SceneKit
import SpriteKit

protocol SVRFSceneOverlayLoader {
    func setOverlayModel(_ model: SceneOverlayModel)
}

struct SVRFViewportBindingExtension: GLTFCodable {
    
    struct SVRFViewportBinding: Codable {
        let image: String?
    }
    let data: SVRFViewportBinding?

    enum CodingKeys: String, CodingKey {
        case data = "SVRF_viewport"
    }

    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        let model = SceneOverlayModel()
        model.image = data?.image
        unarchiver.setOverlayModel(model)
    }
    
}

