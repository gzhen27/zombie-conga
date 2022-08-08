//
//  ExtensionCGPoint.swift
//  ZombieConga
//
//  Created by G Zhen on 8/8/22.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
}
