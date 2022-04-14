//
//  Container.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import Swinject

extension Container {
    
    func registerDependencies(){
        registerService()
        registerRepository()
        registerReactor()
        registerViewController()
        registerView()
    }
    
    private func registerService(){
        register(CacheServiceType.self) {r in CacheService()}.inObjectScope(.container)
        register(NetworkServiceType.self) {r in NetworkService()}
    }
    
    private func registerRepository() {
        register(PhotoRepositoryType.self) {r in
            let cache = r.resolve(CacheServiceType.self)!
            let network = r.resolve(NetworkServiceType.self)!
            let repo = PhotoRepository(cacheService: cache, networkService: network)
            return repo
        }
    }
    
    private func registerReactor(){
        register(PhotoReactor.self) {r in
            let repo = r.resolve(PhotoRepositoryType.self)!
            let reactor = PhotoReactor(photoRepository: repo)
            return reactor
        }
    }
    
    private func registerViewController(){
        register(PhotoViewController.self) {r in
            let reactor = r.resolve(PhotoReactor.self)!
            let vc = PhotoViewController(reactor: reactor)
            return vc
        }
    }
    
    private func registerView(){
        
    }
}
