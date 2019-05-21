//
//  GLTFTypes.swift
//  GLTFSceneKit
//
//  Created by magicien on 2017/08/18.
//  Copyright © 2017 DarkHorse. All rights reserved.
//

import SceneKit

let attributeMap: [String: SCNGeometrySource.Semantic] = [
    "POSITION": SCNGeometrySource.Semantic.vertex,
    "NORMAL": SCNGeometrySource.Semantic.normal,
    "TANGENT": SCNGeometrySource.Semantic.tangent,
    "TEXCOORD_0": SCNGeometrySource.Semantic.texcoord,
    "TEXCOORD_1": SCNGeometrySource.Semantic.texcoord,
    "COLOR_0": SCNGeometrySource.Semantic.color,
    "JOINTS_0": SCNGeometrySource.Semantic.boneIndices,
    "WEIGHTS_0": SCNGeometrySource.Semantic.boneWeights
]

let GLTF_BYTE = Int(GL_BYTE)
let GLTF_UNSIGNED_BYTE = Int(GL_UNSIGNED_BYTE)
let GLTF_SHORT = Int(GL_SHORT)
let GLTF_UNSIGNED_SHORT = Int(GL_UNSIGNED_SHORT)
let GLTF_UNSIGNED_INT = Int(GL_UNSIGNED_INT)
let GLTF_FLOAT = Int(GL_FLOAT)

let GLTF_ARRAY_BUFFER = Int(GL_ARRAY_BUFFER)
let GLTF_ELEMENT_ARRAY_BUFFER = Int(GL_ELEMENT_ARRAY_BUFFER)

let GLTF_POINTS = Int(GL_POINTS)
let GLTF_LINES = Int(GL_LINES)
let GLTF_LINE_LOOP = Int(GL_LINE_LOOP)
let GLTF_LINE_STRIP = Int(GL_LINE_STRIP)
let GLTF_TRIANGLES = Int(GL_TRIANGLES)
let GLTF_TRIANGLE_STRIP = Int(GL_TRIANGLE_STRIP)
let GLTF_TRIANGLE_FAN = Int(GL_TRIANGLE_FAN)

let GLTF_NEAREST = Int(GL_NEAREST)
let GLTF_LINEAR = Int(GL_LINEAR)
let GLTF_NEAREST_MIPMAP_NEAREST = Int(GL_NEAREST_MIPMAP_NEAREST)
let GLTF_LINEAR_MIPMAP_NEAREST = Int(GL_LINEAR_MIPMAP_NEAREST)
let GLTF_NEAREST_MIPMAP_LINEAR = Int(GL_NEAREST_MIPMAP_LINEAR)
let GLTF_LINEAR_MIPMAP_LINEAR = Int(GL_LINEAR_MIPMAP_LINEAR)

let GLTF_CLAMP_TO_EDGE = Int(GL_CLAMP_TO_EDGE)
let GLTF_MIRRORED_REPEAT = Int(GL_MIRRORED_REPEAT)
let GLTF_REPEAT = Int(GL_REPEAT)

let usesFloatComponentsMap: [Int: Bool] = [
    GLTF_BYTE: false,
    GLTF_UNSIGNED_BYTE: false,
    GLTF_SHORT: false,
    GLTF_UNSIGNED_SHORT: false,
    GLTF_UNSIGNED_INT: false,
    GLTF_FLOAT: true
]

let bytesPerComponentMap: [Int: Int] = [
    GLTF_BYTE: 1,
    GLTF_UNSIGNED_BYTE: 1,
    GLTF_SHORT: 2,
    GLTF_UNSIGNED_SHORT: 2,
    GLTF_UNSIGNED_INT: 4,
    GLTF_FLOAT: 4
]

let componentsPerVectorMap: [String: Int] = [
    "SCALAR": 1,
    "VEC2": 2,
    "VEC3": 3,
    "VEC4": 4,
    "MAT2": 4,
    "MAT3": 9,
    "MAT4": 16
]

// GLTF_LINE_LOOP, GLTF_LINE_STRIP, GLTF_TRIANGEL_FAN: need to convert
let primitiveTypeMap: [Int: SCNGeometryPrimitiveType] = [
    GLTF_POINTS: SCNGeometryPrimitiveType.point,
    GLTF_LINES: SCNGeometryPrimitiveType.line,
    GLTF_TRIANGLES: SCNGeometryPrimitiveType.triangles,
    GLTF_TRIANGLE_STRIP: SCNGeometryPrimitiveType.triangleStrip
]

let filterModeMap: [Int: SCNFilterMode] = [
    GLTF_NEAREST: SCNFilterMode.nearest,
    GLTF_LINEAR: SCNFilterMode.linear
]

let wrapModeMap: [Int: SCNWrapMode] = [
    GLTF_CLAMP_TO_EDGE: SCNWrapMode.clamp,
    GLTF_MIRRORED_REPEAT: SCNWrapMode.mirror,
    GLTF_REPEAT: SCNWrapMode.repeat
]

let keyPathMap: [String: String] = [
    "translation": "position",
    "rotation": "orientation",
    "scale": "scale"
]

import AVKit

// TODO(artem): rename this to something that can encompass both
// images and video, but that isn't "texture" (that's a glTF thing)
enum Image {
    case Photo(Data)
    case Video(URL)
}

extension Image {
    var contents: Any? {
        switch self {
        case .Photo(let data):
            #if SEEMS_TO_HAVE_PNG_LOADING_BUG
            let magic: UInt64 = data.subdata(in: 0..<8).withUnsafeBytes { $0.pointee }
            if magic == 0x0A1A0A0D474E5089 {
                // PNG file
                let cgDataProvider = CGDataProvider(data: data as CFData)
                guard let cgImage = CGImage(pngDataProviderSource: cgDataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent) else {
                    print("loadImage error: cannot create CGImage")
                    return nil
                }

                #if os(macOS)
                    let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
                    return NSImage(cgImage: cgImage, size: imageSize)
                #else
                    // FIXME: this workaround doesn't work for iOS...
                    return UIImage(cgImage: cgImage)
                #endif
            }
            #endif
            #if os(macOS)
                return NSImage(data: data)
            #elseif os(iOS) || os(tvOS) || os(watchOS)
                return UIImage(data: data)
            #endif
        case .Video(let url):
            let player = AVPlayer(url: url)
            player.play()
            
            if let error = player.error {
                print("Error playing url:", error)
            }
            
            return player
        }
    }
}

public protocol GLTFCodable: Codable {
    func didLoad(by object: Any, unarchiver: GLTFUnarchiver)
}

protocol GLTFPropertyProtocol: GLTFCodable {
    /** Dictionary object with extension-specific objects. */
    var extensions: GLTFExtension? { get }
    
    /** Application-specific data. */
    var extras: GLTFExtras? { get }
}

extension GLTFPropertyProtocol {
    func didLoad(by object: Any, unarchiver: GLTFUnarchiver) {
        if let extensions = self.extensions?.extensions {
            for ext in extensions.values {
                if let codable = ext as? GLTFCodable {
                    codable.didLoad(by: object, unarchiver: unarchiver)
                }
            }
        }
    }
}


