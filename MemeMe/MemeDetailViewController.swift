//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by grace montoya on 6/30/16.
//  Copyright © 2016 grace montoya. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedMeme:Meme!
    
    @IBOutlet weak var meme: UIImageView!
    
    override var prefersStatusBarHidden : Bool {
        return true     // status bar should be hidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        meme.image = selectedMeme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
