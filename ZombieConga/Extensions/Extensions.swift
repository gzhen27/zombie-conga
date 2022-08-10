//
//  Extensions.swift
//  ZombieConga
//
//  Created by G Zhen on 8/8/22.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    /**
     atan2 - returns the angle between the positive x axis and the ray from the origin to the point(x,y)
     */
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    /**
     return the length from any point(x,y) to the origin point(0,0)
     */
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    /**
     converts a vector  into a unit vector
     */
    func normalized() -> CGPoint {
        return self / length()
    }
    
}

extension CGFloat {
    
    /**
     return 1 if the it is greater than or equal to 0, otherwise returns -1
     */
    func sign() -> CGFloat {
        return self >= 0.0 ? 1.0 : -1.0
    }
    
    /**
     generate a random CGFloat number in a range between 0 and 1
     */
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    /**
     generate a random CGFloat number in a range between min and max
     */
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
