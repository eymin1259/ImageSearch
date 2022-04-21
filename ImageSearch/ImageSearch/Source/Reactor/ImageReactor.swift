//
//  ImageReactor.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import ReactorKit

final class ImageReactor : Reactor {

    //MARK: properties
    enum Action {
        case inputQuery(String)
    }
    
    enum Mutation {
        case setImages([Image])
    }
    
    struct State {
        var imageSection : [ImageListSection]?
    }
    
    let initialState: State
    var imageRepository : ImageRepositoryType
    
    // MARK: initialize
    init(imageRepository : ImageRepositoryType) {
        self.initialState  = .init()
        self.imageRepository = imageRepository
    }
}

extension ImageReactor {
    
    //MARK: Mutate
    func mutate(action: ImageReactor.Action) -> Observable<ImageReactor.Mutation> {
        switch action {
        case .inputQuery(let query):
            return self.imageRepository.getImages(query: query, page: 1)
                .asObservable()
                .compactMap { Mutation.setImages($0) }
        }
    }
    
    //MARK: Reduce
    func reduce(state: State, mutation: ImageReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let imageList):
            newState.imageSection = [.init(images: imageList)]
        }
        return newState
    }
}
