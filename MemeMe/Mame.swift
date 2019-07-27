//
//  Meme.swift
//  MemeMe
//
//  Created by Kadisius, Pijus on 7/27/19.
//  Copyright © 2019 pk. All rights reserved.
//
import Foundation
import UIKit

class Meme {
    var top: String = ""
    var bottom: String = ""
    var image: UIImage = UIImage()
    var memedImage: UIImage = UIImage()
    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memedImage = memedImage
    }
}
