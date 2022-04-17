//
//  ImageRepository.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation


protocol ImageRepositoryType {
    
}

final class ImageRepository : ImageRepositoryType {
    
    var cacheService : CacheServiceType
    var networkService : NetworkServiceType
    
    init(cacheService : CacheServiceType, networkService : NetworkServiceType) {
        self.cacheService = cacheService
        self.networkService = networkService
    }
}
