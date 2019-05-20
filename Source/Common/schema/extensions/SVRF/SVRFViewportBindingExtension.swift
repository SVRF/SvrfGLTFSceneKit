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

enum SVRFVerticalAlignment: String, Codable {
    case center = "center"
    case top = "top"
    case bottom = "bottom"
}

enum SVRFHorizontalAlignment: String, Codable {
    case center = "center"
    case left = "left"
    case right = "right"
}

struct SVRFViewportBindingExtension: GLTFCodable {
    
    struct SVRFViewportBinding: Codable {
        let image: String?
        let valign: SVRFVerticalAlignment?
        let halign: SVRFHorizontalAlignment?

        private enum CodingKeys: String, CodingKey {
            case image
            case valign
            case halign
        }
    }

    let data: SVRFViewportBinding?

    enum CodingKeys: String, CodingKey {
        case data = "SVRF_viewport"
    }

    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        let model = SceneOverlayModel()
        model.image = data?.image
        model.halign = data?.halign
        model.valign = data?.valign
        unarchiver.setOverlayModel(model)
    }
    
}

