//
//  MemeTableTableViewController.swift
//  MemeMe
//
//  Created by grace montoya on 6/30/16.
//  Copyright © 2016 grace montoya. All rights reserved.
//

import UIKit

class MemeTableTableViewController: UITableViewController {
    //gets the memes
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    // hides status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //reloads data
    override func viewWillAppear(_ animated:Bool){
        tableView.reloadData()
        if memes.count > 0 {
             self.navigationItem.leftBarButtonItem?.isEnabled = true
        } else {
             self.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
    }
    
    // removes a row when the edit button is clicked or the row is swiped
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(memes.count)
        return memes.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeTableViewCell
        //print(indexPath.row)
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memedImage
        cell.memeLabel.text = meme.topTextField
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.item]
        detailController.selectedMeme = meme
        detailController.hidesBottomBarWhenPushed = true
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
