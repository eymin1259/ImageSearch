//
//  ImageDTO.swift
//  ImageSearch
//
//  Created by yongmin lee on 5/10/22.
//

import Foundation

struct ImageDTO : Codable, Equatable {
    var thumbnail_url : String
    var image_url : String
    var width : Int
    var height : Int
    var display_sitename : String?
    var datetime : String?
}
