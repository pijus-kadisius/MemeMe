//
//  SentMemesTableView.swift
//  MemeMe
//
//  Created by Kadisius, Pijus on 7/27/19.
//  Copyright © 2019 pk. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        print("in collectionView memes.count", memes.count);
        
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
}
