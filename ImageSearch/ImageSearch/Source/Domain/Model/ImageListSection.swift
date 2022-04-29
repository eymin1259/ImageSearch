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

extension ImageListSection : SectionModelType {
    
    var items: [Image] {
        return self.images
    }
    
    init(original: ImageListSection, items: [Image]) {
        self = original
        self.images = items
    }
}
