//
//  MockImageRepository.swift
//  ImageSearchTests
//
//  Created by yongmin lee on 5/2/22.
//

import Foundation
import XCTest
import RxSwift
@testable import ImageSearch

final class MockImageRepository : ImageRepositoryType {
    
    private var makeFailedGetImages = false
    
    func setGetImages(toFail isFail : Bool) {
        self.makeFailedGetImages = isFail
    }
    
    func getImages(query: String, page: Int) -> Observable<Result<SearchResponseDTO<ImageAPI.Documents>, Error>> {
        return Observable<Result<SearchResponseDTO<ImageAPI.Documents>, Error>>.create { [weak self] emit in
            guard let self = self else {
                emit.onNext(.failure(NetworkError.unknown))
                emit.onCompleted()
                return Disposables.create()
            }
            if self.makeFailedGetImages {
                emit.onNext(.failure(NetworkError.client))
                emit.onCompleted()
            } else {
                let sampleData = try! JSONDecoder().decode(SearchResponseDTO<ImageAPI.Documents>.self, from: ImageAPI.searchImages(query: "", page: 1).sampleData)
                emit.onNext(.success(sampleData))
                emit.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
}
