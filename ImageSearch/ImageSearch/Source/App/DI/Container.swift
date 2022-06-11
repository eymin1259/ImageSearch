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
        registerUseCase()
        registerReactor()
        registerViewController()
    }
    
    private func registerService(){
        register(NetworkServiceType.self) {r in NetworkService()}
    }
    
    private func registerRepository() {
        register(ImageRepository.self) {r in
            let network = r.resolve(NetworkServiceType.self)!
            let repo = ImageRepositoryImpl(networkService: network)
            return repo
        }
    }
    
    private func registerUseCase() {
        register(ImageUseCase.self) {r in
            let repo = r.resolve(ImageRepository.self)!
            let useCase = ImageUseCaseImpl(imageRepository: repo)
            return useCase
        }
    }
    
    private func registerReactor(){
        register(SearchImageReactor.self) {r in
            let useCase = r.resolve(ImageUseCase.self)!
            let reactor = SearchImageReactor(searchImageUseCase: useCase)
            return reactor
        }
    }
    
    private func registerViewController(){
        register(SearchImageViewController.self) {r in
            let reactor = r.resolve(SearchImageReactor.self)!
            let vc = SearchImageViewController(reactor: reactor)
            return vc
        }
    }
}
