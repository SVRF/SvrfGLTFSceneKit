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

        if let halign = data.halign {
            (model.halign, model.hoffset) = SvrfViewportBindingExtension.parseHorizontalAlignment(halign)
        }
        
        if let valign = data.valign {
            (model.valign, model.voffset) = SvrfViewportBindingExtension.parseVerticalAlignment(valign)
        }
    
        do {
            try unarchiver.setOverlayModel(model)
        } catch {
            print("Error loading overlay model: \(error)")
        }
    }
}

/* Layout parsing */
extension SvrfViewportBindingExtension {
    
    /*
     Alignment can take the form of alignment +/- offset%, e.g. "center+10%"
     */

    static func parseHorizontalAlignment(_ halign: String) -> (SvrfHorizontalAlignment?, CGFloat?) {
        let (align, percentage) = parseAlignWithPercentage(halign)
        return (SvrfHorizontalAlignment(rawValue: align), percentage ?? 0)
    }
    
    static func parseVerticalAlignment(_ valign: String) -> (SvrfVerticalAlignment?, CGFloat?) {
        let (align, percentage) = parseAlignWithPercentage(valign)
        return (SvrfVerticalAlignment(rawValue: align), percentage ?? 0)
    }
    
    private static func parseAlignWithPercentage(_ input: String) -> (String, CGFloat?) {
        var align: String
        var percentage: CGFloat?
        
        let normalized = normalizeString(input)
        if let addition = normalized.firstIndex(of: "+") {
            align = String(normalized[..<addition])
            percentage = percentageFrom(String(normalized.suffix(from: addition)))
        } else {
            if let subtraction = normalized.firstIndex(of: "-") {
                align = String(normalized[..<subtraction])
                percentage = (percentageFrom(String(normalized.suffix(from: subtraction))) ?? 0)
                
            } else {
                align = normalized
                percentage = 0
            }
        }
        
        return (align, percentage)
    }
    
    // Converts e.g. 10% to 0.10, or -12% to -0.12
    private static func percentageFrom(_ input: String) -> CGFloat? {
        guard let percentIdx = input.firstIndex(of: "%") else {
            return nil
        }
        
        // Skip the prefix '+', the number formatter doesn't know what to do with it :(
        let firstIndex = input.hasPrefix("+")
            ? input.index(input.startIndex, offsetBy:"+".count)
            : input.startIndex

        let rawNumber = input[firstIndex..<percentIdx]
        return CGFloat(NumberFormatter().number(from: String(rawNumber))?.floatValue ?? 0) / 100.0
    }
    
    // Strips whitespace, lowercases
    private static func normalizeString(_ input: String) -> String {
        let passed = input.unicodeScalars.filter { !NSCharacterSet.whitespaces.contains($0) }
        return String(String.UnicodeScalarView(passed)).lowercased()

    }
    
}
