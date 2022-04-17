//
//  ImageReactor.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import ReactorKit

final class ImageReactor : Reactor {

    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    var imageRepository : ImageRepositoryType
    
    // MARK: Initializers
    
    init(imageRepository : ImageRepositoryType) {
        self.initialState = State()
        self.imageRepository = imageRepository
    }
}

extension ImageReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        return newState
    }
}
