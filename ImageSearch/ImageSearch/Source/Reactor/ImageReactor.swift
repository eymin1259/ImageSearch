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
        case setImages(String, [Image], Bool)
        case appendImages([Image], Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var query : String = ""
        var page : Int = 1
        var imageSection : [ImageListSection] = [.init(images: [Image]())]
        var isEnd : Bool = false
        var isLoading: Bool = false
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
                    Mutation.setImages(query, list.items, list.isEnd)
                }
            
        case .loadMore:
            guard !self.currentState.isLoading else { return .empty() }
            guard !self.currentState.isEnd else { return .empty() }
            let nextPage = self.currentState.page + 1
            let currentQuery = self.currentState.query
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let loadMode = self.imageRepository.getImages(query: currentQuery, page: nextPage)
                .ifEmpty(default: List<Image>.init(items: [Image](), isEnd: true))
                .compactMap { list in
                    Mutation.appendImages(list.items, list.isEnd)
                }
            return .concat([startLoading, loadMode, endLoading])
        }
    }
    
    //MARK: Reduce
    func reduce(state: State, mutation: ImageReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let query, let imageList, let isEnd):
            newState.query = query
            newState.imageSection = [.init(images: imageList)]
            newState.isEnd = isEnd
            newState.page = 1
            return newState
            
        case .appendImages(let imageList, let isEnd):
            let sectionItems = state.imageSection[0].items + imageList
            newState.imageSection = [.init(images: sectionItems)]
            newState.isEnd = isEnd
            newState.page = state.page + 1
            return newState
            
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
