//
//  UIScrollView+Rx.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/24/22.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {

  var isReachedBottom: ControlEvent<Void> {
    let source = self.contentOffset
      .filter { [weak base = self.base] offset in
        guard let base = base else { return false }
        return base.isReachedBottom()
      }
      .map { _ in Void() }
    return ControlEvent(events: source)
  }

}
