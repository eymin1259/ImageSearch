//
//  ImageRepository.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import RxSwift

protocol ImageRepositoryType {
    func getImages(query: String, page : Int) -> Observable<Result<List<Image>, Error>>
}

final class ImageRepository : ImageRepositoryType {
    
    //MARK: properties
    var networkService : NetworkServiceType
    
    //MARK: initialize
    init(networkService : NetworkServiceType) {
        self.networkService = networkService
    }
    
    //MARK: methods
    func getImages(query: String, page : Int) -> Observable<Result<List<Image>, Error>> {
        
        return networkService.request(api: ImageAPI.searchImages(query: query, page: page))
            .map { result  in
                switch result {
                case .success(let data):
                    return .success(List<Image>.init(items: data.documents, isEnd: data.meta.is_end))
                case .failure(let err):
                    return .failure(err)
                }
            }
    }
}
