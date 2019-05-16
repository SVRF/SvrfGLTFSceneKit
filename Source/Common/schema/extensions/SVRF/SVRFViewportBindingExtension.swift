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

    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        print("********************** Loaded extension with object: \(object)")

        unarchiver.setOverlayModel(SceneOverlayModel())
    }
    
}

