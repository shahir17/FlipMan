//
//  Constants.swift
//  SwiftGame
//
//  Created by Shahir Abdul-Satar on 8/18/16.
//  Copyright © 2016 Shahir Abdul-Satar. All rights reserved.
//

import Foundation
import UIKit
//configuration
let kASASGroundHeight: CGFloat = 20.0
//initial variables
let kDefaultXToMovePerSecond: CGFloat = 320.0

//collision detection
let heroCategory: UInt32 = 0x1 << 0
let wallCategory: UInt32 = 0x1 << 1

// game variables
let kNumberOfPointsPerLevel = 5
let kLevelGenerationTimes: [TimeInterval] = [1.0, 0.8, 0.6, 0.4, 0.3]




