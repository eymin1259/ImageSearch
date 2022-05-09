//
//  ImageSectionModel.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/18/22.
//

import Foundation
import RxDataSources

struct ImageListSection {
    var images : [Image]
}

extension ImageListSection : SectionModelType, Equatable {
    
    var items: [Image] {
        return self.images
    }
    
    init(original: ImageListSection, items: [Image]) {
        self = original
        self.images = items
    }
    
    static func == (lhs: ImageListSection, rhs: ImageListSection) -> Bool {
        if lhs.items.count == 0 || rhs.items.count == 0 {
            return false
        }
        if lhs.items.count != rhs.items.count {
            return false
        }
        for idx in 0..<lhs.items.count {
            if lhs.items[idx].image_url != rhs.items[idx].image_url {
                return false
            }
        }
        return true
    }
}
