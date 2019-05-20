//
//  SKSpriteNode+GIF.swift
//  SvrfGLTFSceneKit
//
//  Created by Jesse Boyes on 5/20/19.
//
// A Janky, horrible, half-stolen GIF implementation.
// Only one of these can exist in any app. Don't use it.

import SpriteKit
import ImageIO

extension SKSpriteNode {
    
    private static var _gifSize: CGSize?
    
    var gifSize: CGSize? {
        get {
            return SKSpriteNode._gifSize
        }
    }
    
    convenience init(gifNamed gif: String) {
        self.init()

        animateWithGIF(fileNamed: gif)
    }
    
    func animateWithGIF(fileNamed name:String){
        
        // Check gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: nil) else {
                print("GIF: The image \"\(name)\" does not exist")
                return
        }
        
        // Validate data
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("GIF: Cannot convert image \"\(name)\" into NSData")
            return
        }
        
        if let textures = SKSpriteNode.gifWithData(imageData) {
            SKSpriteNode._gifSize = textures[0].size()

            let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
            self.run(action)
        }
    }
    
    public class func gifWithData(_ data: NSData) -> [SKTexture]? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("GIF: Source for the image does not exist")
            return nil
        }
        
        return SKSpriteNode.animatedImageWithSource(source)
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> [SKTexture]? {
        let count = CGImageSourceGetCount(source)
        var delays = [Int]()
        var textures = [SKTexture]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: image)
                textures.append(texture)
            }
            
            // At it's delay in cs
            let delaySeconds = SKSpriteNode.delayForImageAtIndex(i, source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        /*
         // TODO: - Seems like this will be necessary for correct GIF timing :-/
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        
        // may use later
        let timePerTexture = Double(duration) / 1000.0 / Double(count)
 */
        
        return textures
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = SKSpriteNode.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 unsafeBitCast(kCGImagePropertyGIFDictionary,
                                               to: UnsafeRawPointer.self)),
            to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 unsafeBitCast(kCGImagePropertyGIFUnclampedDelayTime,
                                               to: UnsafeRawPointer.self)),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             unsafeBitCast(kCGImagePropertyGIFDelayTime,
                                                                           to: UnsafeRawPointer.self)),
                                        to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    private class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Handle nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    
    
}
