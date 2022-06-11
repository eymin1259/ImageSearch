//
//  ImageRepositoryImpl.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import RxSwift

final class ImageRepositoryImpl : ImageRepository {
    
    //MARK: properties
    var networkService : NetworkServiceType
    
    //MARK: initialize
    init(networkService : NetworkServiceType) {
        self.networkService = networkService
    }
    
    //MARK: methods
    func getImages(query: String, page : Int) -> Observable<Result<SearchResponseDTO<ImageAPI.Documents>, Error>> {
        return networkService.request(api: ImageAPI.searchImages(query: query, page: page))
    }
}
