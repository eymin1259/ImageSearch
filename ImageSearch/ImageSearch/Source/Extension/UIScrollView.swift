//
//  UIScrollView.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/24/22.
//

import UIKit

extension UIScrollView {
    
    func isReachedBottom() -> Bool{
        if self.contentOffset.y == 0 {
            return false
        }
        let bottomEdge = Float(self.contentOffset.y + self.frame.size.height)
        if CGFloat(bottomEdge) >= self.contentSize.height - 1 {
            return true
        }
        else {
            return false
        }
    }
}
