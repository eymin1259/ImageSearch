//
//  SearchImageUseCase.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/29/22.
//

import Foundation
import RxSwift

protocol SearchImageUseCaseType {
    func execute(query:String, page:Int) -> Observable<Result<List<Image>, Error>>
}

final class SearchImageUseCase : SearchImageUseCaseType {

    //MARK: properties
    var imageRepository : ImageRepositoryType
    
    // MARK: initialize
    init(imageRepository : ImageRepositoryType) {
        self.imageRepository = imageRepository
    }
    
    //MARK: methods
    func execute(query: String, page: Int) -> Observable<Result<List<Image>, Error>> {
        return self.imageRepository.getImages(query: query, page: page)
            .map { result  in
                switch result {
                case .success(let data):
                    let domainImages = data.documents.map { item in
                        return Image(thumbnail_url: item.thumbnail_url, image_url: item.image_url, width: item.width, height: item.height)
                    }
                    return .success(List<Image>.init(items: domainImages, isEnd: data.meta.is_end))
                case .failure(let err):
                    return .failure(err)
                }
            }
    }
}

