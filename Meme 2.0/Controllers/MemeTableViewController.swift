//
//  MemeTableViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 03.05.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes:[Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.userModifiedImage
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText

        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailViewController.memeItem = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
