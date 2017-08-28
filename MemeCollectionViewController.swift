//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by grace montoya on 6/30/16.
//  Copyright © 2016 grace montoya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {
    // get the memes
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // status bar should be hidden
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        var dimension: CGFloat = 0.0
        // get dimensions for collection cells
        func getDimension()->CGFloat {
            var frameDimension:CGFloat = 0
            
            switch(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            case true:  //landsacape mode
                frameDimension = view.frame.size.height
            case false: //portrait mode
                frameDimension = view.frame.size.width
            }
            
            return (frameDimension - (2 * space)) / 3.0
        }
        
        
        dimension = getDimension()
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    // reloads data
    override func viewWillAppear(_ animated:Bool){
        collectionView?.reloadData()
    }

   //number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    // cell for item
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DetailCollectionViewCell
    
        // Configure the cell
        let meme = memes[indexPath.item]
        cell.detailCollectionCell?.image = meme.memedImage
    
        return cell
    }
    

    // did select item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.item]
        detailController.selectedMeme = meme
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}
