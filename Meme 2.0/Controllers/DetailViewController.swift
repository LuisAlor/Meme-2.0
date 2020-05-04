//
//  DetailViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 04.05.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailMemeImageView: UIImageView!
    
    var memeItem:Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let detailMemeImage = self.detailMemeImageView{
            detailMemeImage.image = self.memeItem.userModifiedImage
        }
    }

}
