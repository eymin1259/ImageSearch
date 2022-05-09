//
//  MockSearchImageUseCase.swift
//  ImageSearchTests
//
//  Created by yongmin lee on 5/9/22.
//

import Foundation
import RxSwift
@testable import ImageSearch

final class MockSearchImageUseCase : SearchImageUseCaseType {
    
    private var makeExecuteFail = false
    
    func setExecute(toFail isFail : Bool) {
        self.makeExecuteFail = isFail
    }
    
    func execute(query: String, page: Int) -> Observable<Result<List<Image>, Error>> {
        
        return Observable<Result<List<Image>, Error>>.create { [weak self] emit in
            guard let self = self else {
                emit.onNext(.failure(NetworkError.unknown))
                emit.onCompleted()
                return Disposables.create()
            }
            if self.makeExecuteFail {
                emit.onNext(.failure(NetworkError.client))
                emit.onCompleted()
            } else {
                let sampleData = try! JSONDecoder().decode(SearchResponseDTO<ImageAPI.Documents>.self, from: ImageAPI.searchImages(query: "", page: 1).sampleData)
                
                let domainImages = sampleData.documents.map { item in
                    return Image(thumbnail_url: item.thumbnail_url, image_url: item.image_url, width: item.width, height: item.height)
                }
                emit.onNext(.success(List<Image>.init(items: domainImages, isEnd: sampleData.meta.is_end)))
                emit.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
}
