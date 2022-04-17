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
        case searchImages([Image])
    }
    
    struct State {
        var imageList = [Image]()
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
            let path = Bundle.main.path(forResource: "Mock", ofType: "json") ?? ""
            let jsonString = try? String(contentsOfFile: path) ?? ""
            let decoder = JSONDecoder()
            let data = jsonString!.data(using: .utf8)
            if let data = data,
               let res = try? decoder.decode(Response<Image>.self, from: data) {
                return Observable.just(Mutation.searchImages(res.documents))
            }
            else{
                return Observable.just(Mutation.searchImages([]))
            }
     
        }
    }
    
    //MARK: Reduce
    func reduce(state: State, mutation: ImageReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .searchImages(let imageList):
            newState.imageList = imageList
        }
        return newState
    }
}
