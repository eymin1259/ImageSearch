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
        case showError(Error)
    }
    
    struct State {
        var query : String = ""
        var page : Int = 1
        var imageSection : [ImageListSection] = [.init(images: [Image]())]
        var isEnd : Bool = false
        var isLoading: Bool = false
        var errResult : Error?
    }
    
    let initialState: State
    var searchImageUseCase : SearchImageUseCaseType
    
    // MARK: initialize
    init(searchImageUseCase : SearchImageUseCaseType) {
        self.initialState  = .init()
        self.searchImageUseCase = searchImageUseCase
    }
}

extension ImageReactor {
    
    //MARK: Mutate
    func mutate(action: ImageReactor.Action) -> Observable<ImageReactor.Mutation> {
        switch action {
        case .inputQuery(let query):
            return self.searchImageUseCase.execute(query: query, page: 1)
                .map { result in
                    switch result {
                    case .success(let list):
                        return Mutation.setImages(query, list.items, list.isEnd)
                    case .failure(let err):
                        return Mutation.showError(err)
                    }
                }
            
        case .loadMore:
            guard !self.currentState.isLoading else { return .empty() }
            guard !self.currentState.isEnd else { return .empty() }
            let nextPage = self.currentState.page + 1
            let currentQuery = self.currentState.query
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let loadMoreRes = self.searchImageUseCase.execute(query: currentQuery, page: nextPage)
                .map { result -> ImageReactor.Mutation in
                    switch result {
                    case .success(let list):
                        return  Mutation.appendImages(list.items, list.isEnd)
                    case .failure(let err):
                        return Mutation.showError(err)
                    }
                }
            return .concat([startLoading, loadMoreRes, endLoading])
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
            newState.errResult = nil
            return newState
            
        case .appendImages(let imageList, let isEnd):
            let sectionItems = state.imageSection[0].items + imageList
            newState.imageSection = [.init(images: sectionItems)]
            newState.isEnd = isEnd
            newState.page = state.page + 1
            newState.errResult = nil
            return newState
            
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
            
        case .showError(let err):
            newState.errResult = err
            return newState
        }
    }
}
