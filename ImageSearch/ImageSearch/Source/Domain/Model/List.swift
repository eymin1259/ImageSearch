//
//  List.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/24/22.
//

import Foundation

struct List<Item> {
    var items: [Item]
    var isEnd : Bool
    
    init(items: [Item], isEnd: Bool) {
        self.items = items
        self.isEnd = isEnd
    }
}
