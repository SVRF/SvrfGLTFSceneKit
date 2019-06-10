//
//  Data+Conversions.swift
//  GLTFSceneKit
//
//  Created by Jesse Boyes on 6/10/19.
//  Copyright © 2019 DarkHorse. All rights reserved.
//

import Foundation

extension Data {
    public func toUInt32() throws -> UInt32 {
        if (self.count != 4) {
            throw GLTFUnarchiveError.DataInconsistent("Attempt to convert UInt32 from \(self.count) bytes")
        }

        return self.withUnsafeBytes { (bytes) -> UInt32 in
            return bytes.baseAddress!.assumingMemoryBound(to: UInt32.self).pointee
        }
    }

    public func toUInt64() throws -> UInt64 {
        if (self.count != 8) {
            throw GLTFUnarchiveError.DataInconsistent("Attempt to convert UInt64 from \(self.count) bytes")
        }

        return self.withUnsafeBytes { (bytes) -> UInt64 in
            return bytes.baseAddress!.assumingMemoryBound(to: UInt64.self).pointee
        }
    }

}
