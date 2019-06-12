//
//  SvrfSceneOverlay.swift
//  SvrfGLTFSceneKit
//
//  Created by Jesse Boyes on 6/12/19.
//

import Foundation
import SpriteKit

public class SvrfSceneOverlay: SKScene {
    private var imageNode: SKNode?
    private var halign: SvrfHorizontalAlignment?
    private var valign: SvrfVerticalAlignment?
    private var hoffset: CGFloat?
    private var voffset: CGFloat?

    init(image: SKNode,
         halign: SvrfHorizontalAlignment?,
         hoffset: CGFloat?,
         valign: SvrfVerticalAlignment?,
         voffset: CGFloat?) {
        super.init()
        self.imageNode = image
        self.halign = halign
        self.hoffset = hoffset
        self.valign = valign
        self.voffset = voffset

        if let imageNode = imageNode {
            self.addChild(imageNode)
        }
    }

    required public override init(size: CGSize) {
        super.init(size: size)
    }

    required init(coder: NSCoder) {
        super.init()
        assertionFailure("Not implemented")
    }

    override public func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)

        layoutImage()
    }

    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        layoutImage()
    }

    private func layoutImage() {
        guard let imageNode = imageNode else {
            return
        }

        let imageSize = imageNode.frame.size
        let frameSize = self.frame.size
        var x: CGFloat
        var y: CGFloat
        switch halign ?? .center {
        case .center: x = frameSize.width/2
        case .left: x = imageSize.width/2
        case .right: x = frameSize.width - (imageSize.width/2)
        }
        if let hoffset = hoffset {
            x += hoffset*frameSize.width
        }

        switch valign ?? .center {
        case .center: y = frameSize.height/2
        case .bottom: y = imageSize.height/2
        case .top: y = frameSize.height - (imageSize.height/2)
        }
        if let voffset = voffset {
            y += voffset*frameSize.height
        }

        imageNode.position = CGPoint(x: x, y: y)
    }
}
