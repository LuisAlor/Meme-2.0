//
//  DetailViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 04.05.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var detailMemeImageView: UIImageView!
    
    // MARK: Properties
    var memeItem:Meme!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Assign the meme to our imageView
        if let detailMemeImage = self.detailMemeImageView{
            detailMemeImage.image = self.memeItem.userModifiedImage
        }
    }

}
