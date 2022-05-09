//
//  ImageRepositoryType.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/29/22.
//

import Foundation
import RxSwift

protocol ImageRepositoryType {
    func getImages(query: String, page : Int) -> Observable<Result<SearchResponseDTO<ImageAPI.Documents>, Error>>
}
