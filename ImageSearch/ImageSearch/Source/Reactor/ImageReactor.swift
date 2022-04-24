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
        case loadMore
    }
    
    enum Mutation {
        case setImages([Image], Bool)
    }
    
    struct State {
        var imageSection : [ImageListSection]?
        var isEnd : Bool = false
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
                .ifEmpty(default: List<Image>.init(items: [Image](), isEnd: true))
                .compactMap { list in
                    Mutation.setImages(list.items, list.isEnd)
                }
        case .loadMore:
            
        }
    }
    
    //MARK: Reduce
    func reduce(state: State, mutation: ImageReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let imageList, let isEnd):
            newState.imageSection = [.init(images: imageList)]
            newState.isEnd = isEnd
        }
        return newState
    }
}
