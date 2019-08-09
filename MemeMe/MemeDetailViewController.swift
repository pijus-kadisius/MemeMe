//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kadisius, Pijus on 8/7/19.
//  Copyright © 2019 pk. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memedImage.image = meme.memedImage
    }
}
