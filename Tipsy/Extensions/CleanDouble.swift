//
//  CleanDouble.swift
//  TypoSizer
//
//  Created by Adrien Leloup on 15/05/18.
//  Copyright © 2018 voidgraphics. All rights reserved.
//

import Cocoa

extension Double {
    var clean: String {
        return String(format: "%.02f", self)
    }
}
