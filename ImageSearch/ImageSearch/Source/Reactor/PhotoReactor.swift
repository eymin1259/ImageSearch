//
//  SearchReactor.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import ReactorKit

final class PhotoReactor : Reactor {

    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    
    // MARK: Initializers
    
    init(photoRepository : PhotoRepositoryType) {
        self.initialState = State()
    }
}

extension PhotoReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        return newState
    }
}
