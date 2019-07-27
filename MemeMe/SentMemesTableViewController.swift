//
//  SentMemesTableView.swift
//  MemeMe
//
//  Created by Kadisius, Pijus on 7/27/19.
//  Copyright © 2019 pk. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController {
    var memes: [Meme] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
    }
}
