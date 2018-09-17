//
//  Utilidades.swift
//  MataMoscas
//
//  Created by jesus on 17/9/18.
//  Copyright © 2018 Jesus. All rights reserved.
//

import Foundation
import SpriteKit

func genRamdom(min: Int, max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32((max - min) + 1)))
}

func getPos(widthDevice: CGFloat, heightDevice: CGFloat) -> CGPoint {
    let moveX = genRamdom(min: Int(-widthDevice), max: Int(widthDevice))
    let moveY = genRamdom(min: Int(-heightDevice), max: Int(heightDevice))
    
    return CGPoint(x: moveX, y: moveY)
}
