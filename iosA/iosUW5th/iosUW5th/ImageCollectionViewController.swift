//
//  ImageCollectionViewController.swift
//  iosUW5th
//
//  Created by wenyu zhao on 05/03/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController {
    var imageName = ["girl", "pal", "saski", "scene", "taipei"]
    var imageGallay = ["girl": "this is good girl",
                       "pal": "this is a RPG role",
                       "saski": "this is a cartoon role",
                       "scene": "this is good scene",
                       "taipei": "this is Taipei"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGallay.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        item.imageView.image = UIImage.init(named: self.imageName[indexPath.item])
        item.imageDescription.text = self.imageGallay[self.imageName[indexPath.item]]
        return item
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        switch (collectionView?.collectionViewLayout as! ImageCollectionFlowLayout).scrollDirection {
        case .horizontal:
            (collectionView?.collectionViewLayout as! ImageCollectionFlowLayout).scrollDirection = .vertical
        case .vertical:
            (collectionView?.collectionViewLayout as! ImageCollectionFlowLayout).scrollDirection = .horizontal
        }
    }
}
