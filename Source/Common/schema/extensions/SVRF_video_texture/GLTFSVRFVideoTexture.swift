//
//  SVRF_video_texture.swift
//  Pods-FaceFilter Studio
//
//  Created by Artem on 5/30/19.
//

import Foundation
import SceneKit

struct GLTFSvrfVideoTextureExtension: GLTFCodable {
    struct GLTFSvrfVideoTextureSchema: Codable {
        var diffuse: Int?

        private enum CodingKeys: String, CodingKey {
            case diffuse
        }
    }
    
    let data: GLTFSvrfVideoTextureSchema?
    enum CodingKeys: String, CodingKey {
        case data = "SVRF_video_texture"
    }
    
    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        guard let data = self.data else { return }
        guard let material = object as? SCNMaterial else { return }
        
        if let diffuse = data.diffuse {
            try! unarchiver.setTexture(index: diffuse, to: material.diffuse)
        }
    }
}
