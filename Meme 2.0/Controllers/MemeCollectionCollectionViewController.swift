//
//  MemeCollectionCollectionViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 03.05.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class MemeCollectionCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    var memes:[Meme]! {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: Initialize all when view is instantiated for first time
    override func viewDidLoad() {
      
        super.viewDidLoad()
        //Set Spacing in collection flowLayout
        let space: CGFloat = 1.0
        let dimension_width = (view.frame.size.width - (2 * space)) / 1.0
        let dimension_height = (view.frame.size.height - (2 * space)) / 1.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension_width, height: dimension_height)
    }
        
    //MARK: viewWillAppear method: Reload data when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //Reload data in the collectionview
        collectionView!.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    
    // MARK: numberOfItemsInSection method: Return num of memes for collectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    // MARK: cellForItemAt method: Return a custom MemeCollectionViewCell with image
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.memeImage?.image = meme.userModifiedImage
        
        return cell
    }
        
    // MARK: didSelectItemAt method: Create an instance of detailViewController and push it

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailViewController.memeItem = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    

}
