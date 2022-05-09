//
//  SearchResponse.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/17/22.
//

import Foundation

struct SearchResponseDTO<Item : Codable> : Codable{
    var meta : Meta
    var documents : Item
}

extension SearchResponseDTO {
    struct Meta : Codable {
        var total_count : Int
        var pageable_count : Int
        var is_end : Bool
    }
}
