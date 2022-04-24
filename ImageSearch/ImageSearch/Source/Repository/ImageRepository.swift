//
//  ImageRepository.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import RxSwift

protocol ImageRepositoryType {
    func getImages(query: String, page : Int) -> Observable<[Image]>
}

final class ImageRepository : ImageRepositoryType {
    
    var networkService : NetworkServiceType
    
    init(networkService : NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getImages(query: String, page : Int) -> Observable<[Image]> {
        return networkService.request(api: ImageAPI.searchImages(query: query, page: page))
            .compactMap { $0.documents }
    }
}
