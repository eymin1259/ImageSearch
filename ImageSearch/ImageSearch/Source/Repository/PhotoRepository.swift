//
//  PhotoRepository.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation


protocol PhotoRepositoryType {
    
}

final class PhotoRepository : PhotoRepositoryType {
    
    var networkService : NetworkServiceType
    var cacheService : CacheServiceType
    
    init(networkService : NetworkServiceType, cacheService : CacheServiceType) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
}
