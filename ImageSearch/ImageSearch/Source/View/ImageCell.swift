//
//  ImageCell.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/16/22.
//

import UIKit
import Kingfisher
import SnapKit

final class ImageCell : UICollectionViewCell {
    
    //MARK: properties
    static let id = "ImageCellID"
    let photoImageView : UIImageView = {
        let imageView : UIImageView = .init(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: initialize
    override init(frame: CGRect) {
      super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      self.photoImageView.image = nil
    }
    
    //MARK: methods
    func setupConstraints() {
        self.contentView.addSubview(photoImageView)
        self.photoImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
    
    func setImage(with urlString : String) {
        guard let url = URL(string:urlString) else { return }
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
          with: url,
          placeholder: nil,
          options: nil,
          completionHandler: nil
        )
    }
}
