//
//  SvrfAnimatedMaterialExtension.swift
//  GLTFSceneKit_macOS
//
//  Created by Roman Chaley on 8/29/19.
//

import Foundation
import SceneKit

protocol SvrfTextureAnimator {
    func animateTexture(_ model: TextureAnimationModel) throws
}

struct SvrfAnimatedMaterialExtension: GLTFCodable {
    struct SvrfAnimatedTextureSchema: Codable {
        let images: [Int]
        let fps: Int?
        
        private enum CodingKeys: String, CodingKey {
            case images
            case fps
        }
    }

    struct SvrfAnimatedMaterialSchema: Codable {
        let baseColorTexture: SvrfAnimatedTextureSchema?
        let metallicRoughnessTexture: SvrfAnimatedTextureSchema?
        let normalTexture: SvrfAnimatedTextureSchema?
        let occlusionTexture: SvrfAnimatedTextureSchema?
        let emissiveTexture: SvrfAnimatedTextureSchema?
        
        private enum CodingKeys: String, CodingKey {
            case baseColorTexture
            case metallicRoughnessTexture
            case normalTexture
            case occlusionTexture
            case emissiveTexture
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "SVRF_animated_material"
    }
    
    private enum AnimatedMaterialError: Error {
        case noImages
        case missingTexture
    }
    
    let defaultFps = 10
    let data: SvrfAnimatedMaterialSchema?

    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        guard let material = object as? SCNMaterial else { return }
        guard let data = self.data else { return }

        do {
            if let baseTextureSchema = data.baseColorTexture {
                try animateTexture(texture: material.diffuse, schema: baseTextureSchema, unarchiver: unarchiver)
            }
            if let metallicTextureSchema = data.metallicRoughnessTexture {
                try animateTexture(texture: material.metalness, schema: metallicTextureSchema, unarchiver: unarchiver)
                try animateTexture(texture: material.roughness, schema: metallicTextureSchema, unarchiver: unarchiver)
            }
            if let normalTextureSchema = data.normalTexture {
                try animateTexture(texture: material.normal, schema: normalTextureSchema, unarchiver: unarchiver)
            }
            if let occlusionTextureSchema = data.occlusionTexture {
                try animateTexture(texture: material.ambientOcclusion, schema: occlusionTextureSchema, unarchiver: unarchiver)
            }
            if let emissiveTextureSchema = data.emissiveTexture {
                try animateTexture(texture: material.emission, schema: emissiveTextureSchema, unarchiver: unarchiver)
            }
        } catch AnimatedMaterialError.noImages {
            print("No images were provided for the SVRF_animated_material extension")
        } catch AnimatedMaterialError.missingTexture {
            print("The texture is missing for the SVRF_animated_material extension")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func animateTexture(texture: SCNMaterialProperty?, schema: SvrfAnimatedTextureSchema, unarchiver: GLTFUnarchiver) throws {
        guard schema.images.count > 0 else {
            throw AnimatedMaterialError.noImages
        }
        
        guard texture != nil else {
            throw AnimatedMaterialError.missingTexture
        }

        let model = TextureAnimationModel()
        model.texture = texture
        model.fps = schema.fps ?? defaultFps
        model.images = schema.images
        
        do {
            try unarchiver.animateTexture(model)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
