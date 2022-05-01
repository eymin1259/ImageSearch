//
//  Entity.Image.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/29/22.
//

import Foundation


extension Entity {    
    struct Image : Codable, Equatable {
        var thumbnail_url : String
        var image_url : String
        var width : Int
        var height : Int
        var display_sitename : String?
        var datetime : String?
    }
}
