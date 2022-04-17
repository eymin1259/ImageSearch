//
//  Image.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/17/22.
//

import Foundation

struct Image : Codable {
    var thumbnail_url : String
    var image_url : String
    var width : Int
    var height : Int
    var display_sitename : String?
    var datetime : String?          
}
