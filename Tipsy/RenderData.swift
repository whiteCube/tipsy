//
//  RenderData.swift
//  Tipsy
//
//  Created by Adrien Leloup on 29/05/18.
//  Copyright © 2018 voidgraphics. All rights reserved.
//

import Cocoa

class RenderData: NSObject {
    var base: Int
    var scale: String
    var text: String
    var font: String
    var steps: Int
    
    init(_ base: Int, _ scale: String, _ text: String, _ font: String, _ steps: Int) {
        self.base = base
        self.scale = scale
        self.text = text
        self.font = font
        self.steps = steps
    }
}
