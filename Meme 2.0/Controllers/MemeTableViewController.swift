//
//  MemeTableViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 03.05.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    var memes:[Meme]! {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: viewWillAppear method: Reload data when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Set tableView Height for image to increase its size
        tableView.rowHeight = 100
        //Reload data in the tableView for memes to show
        tableView!.reloadData()
    }

    // MARK: - Table view data source

    // MARK: numberOfRowsInSection method: Return num of memes for tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return memes.count
    }

    // MARK: cellForRowAt method: Return a cell with our meme image and set its text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.userModifiedImage
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText

        return cell
    }
    
    // MARK: didSelectRowAt method: Instantiate DetailViewController and pass meme
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailViewController.memeItem = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
