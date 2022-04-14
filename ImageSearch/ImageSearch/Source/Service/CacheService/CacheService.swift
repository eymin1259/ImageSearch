//
//  CacheService.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation

protocol CacheServiceType {
    
}

final class CacheService : CacheServiceType{
    
    static let shared = CacheService()
    let cachedImage: NSCache<NSURL, NSData>
    
    private init() {
        cachedImage = .init()
        cachedImage.countLimit = 1000
    }
}
