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
    
    //MARK: properties
    var networkService : NetworkServiceType
    
    //MARK: initialize
    init(networkService : NetworkServiceType) {
        self.networkService = networkService
    }
    
    //MARK: methods
    func getImages(query: String, page : Int) -> Observable<[Image]> {
        return networkService.request(api: ImageAPI.searchImages(query: query, page: page))
            .compactMap { $0.documents }
    }
}
