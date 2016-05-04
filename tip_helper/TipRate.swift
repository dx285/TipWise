//
//  TipRate.swift
//  tip_helper
//
//  Created by Di on 2/2/16.
//  Copyright © 2016 Di. All rights reserved.
//

import Foundation


class TipRate {
    let category: String?
    let bad: String?
    let good: String?
    let excellent: String?
    
    init(category: String, bad: String, good: String, excellent: String){
        self.category = category
        self.bad = bad
        self.good = good
        self.excellent = excellent
    }
}