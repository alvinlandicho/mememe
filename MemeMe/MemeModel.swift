//
//  MemeModel.swift
//  MemeMe
//
//  Created by Alvin Landicho on 5/13/15.
//  Copyright (c) 2015 Alvin Landicho. All rights reserved.
//

import Foundation
import UIKit

// Model for MemeMe App
class MemeModel: NSObject {
    
    var upperText: String!
    var lowerText: String!
    var originalImage: UIImage!
    var memeImage: UIImage!
    
    init (upperText: String, lowerText: String, originalImage: UIImage, memeImage: UIImage) {
        self.upperText = upperText
        self.lowerText = lowerText
        self.originalImage = originalImage
        self.memeImage = memeImage
        
    }
    
}
