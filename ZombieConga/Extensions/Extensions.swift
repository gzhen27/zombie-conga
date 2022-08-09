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
}
