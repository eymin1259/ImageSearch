//
//  ImageCell.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/16/22.
//

import UIKit

final class ImageCell : UICollectionViewCell {
    
    //MARK: properties
    static let id = "ImageCellID"
    
    // MARK: initialize
    override init(frame: CGRect) {
      super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
