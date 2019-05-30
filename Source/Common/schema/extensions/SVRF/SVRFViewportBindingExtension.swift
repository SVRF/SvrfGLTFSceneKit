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
    func setOverlayModel(_ model: SceneOverlayModel) throws
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
        let image: Int?
        let images: [Int]?
        let valign: String?
        let halign: String?

        private enum CodingKeys: String, CodingKey {
            case image
            case images
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
        guard let data = data else {
            print("SVRF Viewport Extension: No data provided")
            return
        }

        model.images = data.images != nil ? data.images : [data.image ?? 0]

        (model.halign, model.hoffset) = parseHorizontalAlignment()
        (model.valign, model.voffset) = parseVerticalAlignment()
        do {
            try unarchiver.setOverlayModel(model)
        } catch {
            print("Error loading overlay model: \(error)")
        }
    }
    
    /*
 Alignment can take the form of "center+10%"
 */
    private func parseHorizontalAlignment() -> (SVRFHorizontalAlignment?, CGFloat?) {
        if let halign = data?.halign {
            var align: String
            var percentage: CGFloat

            let normalized = normalizeString(halign)
            let addition = normalized.index(of: "+")
            if let addition = addition {
                align = String(normalized[..<addition])
                percentage = 0//percentage(normalized.suffix(from: addition))
            }
        }
        return (nil, nil)
    }
    
    private func parseVerticalAlignment() -> (SVRFVerticalAlignment?, CGFloat?) {
        return (.center, 0.0)
    }
    
    // Converts e.g. 10% to 0.10, or -12% to -0.12
    private func percentage(_ input: String) -> CGFloat? {
        return 0//CGFloat(NumberFormatter().number(from: input)?.floatValue)
    }
    
    // Strips whitespace, lowercases
    private func normalizeString(_ input: String) -> String {
        let passed = input.unicodeScalars.filter { !NSCharacterSet.whitespaces.contains($0) }
        return String(String.UnicodeScalarView(passed)).lowercased()

    }
    
}

