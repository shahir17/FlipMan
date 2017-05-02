//
//  ASASPointsLabel.swift
//  SwiftGame
//
//  Created by Shahir Abdul-Satar on 8/18/16.
//  Copyright © 2016 Shahir Abdul-Satar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class ASASPointsLabel: SKLabelNode {
    var number = 0
    
    init(num: Int) {
        super.init()
        
        fontColor = UIColor.black
        fontName = "Helvetica"
        fontSize = 24.0
        
        number = num
        text = "\(num)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment(){
        number += 1
        text = "\(number)"
    }
    
    func setTo(_ num: Int) {
        self.number = num
        text = "\(self.number)"
    }
    
    
    
    
    
    
    
}
