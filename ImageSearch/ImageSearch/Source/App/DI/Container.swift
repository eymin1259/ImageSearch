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
        register(ImageRepositoryType.self) {r in
            let cache = r.resolve(CacheServiceType.self)!
            let network = r.resolve(NetworkServiceType.self)!
            let repo = ImageRepository(cacheService: cache, networkService: network)
            return repo
        }
    }
    
    private func registerReactor(){
        register(ImageReactor.self) {r in
            let repo = r.resolve(ImageRepositoryType.self)!
            let reactor = ImageReactor(imageRepository: repo)
            return reactor
        }
    }
    
    private func registerViewController(){
        register(ImageViewController.self) {r in
            let reactor = r.resolve(ImageReactor.self)!
            let vc = ImageViewController(reactor: reactor)
            return vc
        }
    }
    
    private func registerView(){
        
    }
}
