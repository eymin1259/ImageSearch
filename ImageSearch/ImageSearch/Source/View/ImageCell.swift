//
//  ImageCell.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/16/22.
//

import UIKit
import Kingfisher

final class ImageCell : UICollectionViewCell {
    
    //MARK: properties
    static let id = "ImageCellID"
    var imageData : Image?
    
    // MARK: initialize
    override init(frame: CGRect) {
      super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageData(_ image : Image){
        self.imageData = image
        
        let iv = UIImageView(frame: .init(origin: .zero, size: self.contentView.frame.size))
        
        let url = URL(string: imageData!.thumbnail_url)
        iv.kf.setImage(with: url)

        self.contentView.addSubview(iv)
    }
}
