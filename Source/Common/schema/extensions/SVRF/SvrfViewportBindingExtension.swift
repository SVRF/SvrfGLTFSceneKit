//
//  SVRFViewportBinding.swift
//  SvrfGLTFSceneKit
//
//  Created by Jesse Boyes on 5/15/19.
//

import Foundation
import SceneKit
import SpriteKit

protocol SvrfSceneOverlayLoader {
    func setOverlayModel(_ model: SceneOverlayModel) throws
}

enum SvrfVerticalAlignment: String, Codable {
    case center = "center"
    case top = "top"
    case bottom = "bottom"
}

enum SvrfHorizontalAlignment: String, Codable {
    case center = "center"
    case left = "left"
    case right = "right"
}

struct SvrfViewportBindingExtension: GLTFCodable {
    
    struct SvrfViewportBinding: Codable {
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

    let data: SvrfViewportBinding?

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
    private func parseHorizontalAlignment() -> (SvrfHorizontalAlignment?, CGFloat?) {
        if let halign = data?.halign {
            var align: String
            var percentage: CGFloat?

            let normalized = normalizeString(halign)
            if let addition = normalized.index(of: "+") {
                align = String(normalized[..<addition])
                percentage = percentageFrom(String(normalized.suffix(from: addition)))
            } else {
                if let subtraction = normalized.index(of: "-") {
                    align = String(normalized[..<subtraction])
                    percentage = -(percentageFrom(String(normalized.suffix(from: subtraction))) ?? 0)

                } else {
                    align = normalized
                    percentage = 0
                }
            }
            
            return (SvrfHorizontalAlignment(rawValue: align), percentage ?? 0)
        }
        return (nil, nil)
    }
    
    private func parseVerticalAlignment() -> (SvrfVerticalAlignment?, CGFloat?) {
        return (.center, 0.0)
    }
    
    // Converts e.g. 10% to 0.10, or -12% to -0.12
    private func percentageFrom(_ input: String) -> CGFloat? {
        return CGFloat(NumberFormatter().number(from: input)?.floatValue ?? 0)
    }
    
    // Strips whitespace, lowercases
    private func normalizeString(_ input: String) -> String {
        let passed = input.unicodeScalars.filter { !NSCharacterSet.whitespaces.contains($0) }
        return String(String.UnicodeScalarView(passed)).lowercased()

    }
    
}
