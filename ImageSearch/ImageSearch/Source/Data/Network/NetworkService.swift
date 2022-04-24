//
//  NetworkService.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/14/22.
//

import Foundation
import RxSwift
import Moya
import RxMoya

protocol NetworkServiceType {
    var provider:  MoyaProvider<MultiTarget> { get }
    func request<API>(api: API) -> Observable<SearchResponse<API.Documents>>  where API : BaseServiceAPI
}

final class NetworkService : NetworkServiceType {
    
    static let API_KEY = "4837664397ba0a3531b104d0856d7951"
    var provider : MoyaProvider<MultiTarget>
    
    init() {
        self.provider = NetworkService.makeProvider()
    }
    
    static func makeProvider() -> MoyaProvider<MultiTarget> {
        // Set network logger plugin
        let loggerPlugin = NetworkLoggerPlugin()
        return MoyaProvider<MultiTarget>(plugins: [loggerPlugin])
    }

    func request<API>(api: API) -> Observable<SearchResponse<API.Documents>>  where API : BaseServiceAPI { 
        let endpoint = MultiTarget.target(api)
        return self.provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { try JSONDecoder().decode(SearchResponse<API.Documents>.self, from: $0.data) }
            .catch { err in
                return .empty()
            }
    }
}
