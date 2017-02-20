//
//  SKTriangle.swift
//  Avoid Spikes
//
//  Created by Eric Internicola on 2/27/16.
//  Copyright © 2016 iColasoft. All rights reserved.
//

import SpriteKit

class SKTriangle: SKShapeNode {
    var size = CGSize(width: 0, height: 0)
    var color: UIColor = UIColor.whiteColor() {
        didSet {
            fillColor = color
            strokeColor = color
        }
    }
    
    class func createTriangleOfSize(width: CGFloat, height: CGFloat) -> SKTriangle {
        let triangle = SKTriangle(path: SKTriangle.buildTriangleShape(width, height: height))
        triangle.size = CGSize(width: width, height: height)
        return triangle
    }
}


// MARK: - Helper Methods
extension SKTriangle {
    class func buildTriangleShape(width: CGFloat, height: CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: height))
        path.addLineToPoint(CGPoint(x: width, y: height))
        path.addLineToPoint(CGPoint(x: width/2, y: 0))
        path.addLineToPoint(CGPoint(x: 0, y: height))
        path.closePath()
        return path.CGPath
    }
}