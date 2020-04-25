//
//  ImageCollectionFlowLayout.swift
//  iosUW5th
//
//  Created by wenyu zhao on 05/03/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class ImageCollectionFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if var attrArray = super.layoutAttributesForElements(in: rect) {
            let centerX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.bounds.size.width)!/2.0
            for attr in attrArray {
                let distance = fabs(attr.center.x - centerX)
                let apartScale = distance/(self.collectionView?.bounds.size.width)!
                let scale = fabs(cos(Double(apartScale) * .pi/4))
                attr.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(scale))
            }
            return attrArray
        }
        return nil
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
