//
//  Moment.swift
//  MyProject4 - InstantMomentCapture
//
//  Created by Vitali Vyucheiski on 4/12/22.
//

import UIKit

class Moment: NSObject, Codable {
    var name: String = ""
    var image: String = ""
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
