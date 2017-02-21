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
    var color: UIColor = UIColor.white {
        didSet {
            fillColor = color
            strokeColor = color
        }
    }
    
    class func createTriangleOfSize(_ width: CGFloat, height: CGFloat) -> SKTriangle {
        let triangle = SKTriangle(path: SKTriangle.buildTriangleShape(width, height: height))
        triangle.size = CGSize(width: width, height: height)
        return triangle
    }
}


// MARK: - Helper Methods
extension SKTriangle {
    class func buildTriangleShape(_ width: CGFloat, height: CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width/2, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        return path.cgPath
    }
}
