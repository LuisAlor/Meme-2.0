//
//  MemeCollectionCollectionViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 03.05.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class MemeCollectionCollectionViewController: UICollectionViewController {
    
    var memes:[Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension_width = (view.frame.size.width - (2 * space)) / 3.0
        let dimension_height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension_width, height: dimension_height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.memeImage?.image = meme.userModifiedImage
        
        return cell
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
     */

}
