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
import UIKit

protocol NetworkServiceType {
    var provider:  MoyaProvider<MultiTarget> { get }
    init(
        isStub: Bool,
        sampleStatusCode: Int,
        customEndpointClosure: ((MultiTarget) -> Endpoint)?
    )
    func request<API>(api: API) -> Observable<Result<SearchResponse<API.Documents>, Error>> where API : BaseServiceAPI
}

final class NetworkService : NetworkServiceType {
    
    //MARK: properties
    static let API_KEY = "4837664397ba0a3531b104d0856d7951"
    var provider : MoyaProvider<MultiTarget>
    
    //MARK: initialize
    init(
        isStub: Bool = false,
        sampleStatusCode: Int = 200,
        customEndpointClosure: ((MultiTarget) -> Endpoint)? = nil
    ) {
        self.provider = NetworkService.makeProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
    
    //MARK: methods
    static func makeProvider(
        _ isStub: Bool = false,
        _ sampleStatusCode: Int = 200,
        _ customEndpointClosure: ((MultiTarget) -> Endpoint)? = nil
    ) -> MoyaProvider<MultiTarget> {

        if isStub == false {
            let loggerPlugin = NetworkLoggerPlugin()
            return MoyaProvider<MultiTarget>(plugins: [loggerPlugin])
        }
        else { // 테스트용 provider 생성
            let testEndPointClosure = { (target: MultiTarget) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }
                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
            return MoyaProvider<MultiTarget>(
                endpointClosure: customEndpointClosure ?? testEndPointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }

    func request<API>(api: API) -> Observable<Result<SearchResponse<API.Documents>, Error>>  where API : BaseServiceAPI {
        let endpoint = MultiTarget.target(api)
        return self.provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map {
                let response = try JSONDecoder().decode(SearchResponse<API.Documents>.self, from: $0.data)
                return .success(response)
            }
            .catch { err in
                if let urlErr = err as? URLError,
                   (urlErr.code == .timedOut || urlErr.code == .notConnectedToInternet) {
                    return .just(.failure(urlErr))
                }
                if let statusCode = (err as? MoyaError)?.response?.statusCode,
                   400..<500 ~= statusCode {
                    return .just(.failure(NetworkError.client))
                }
                if let statusCode = (err as? MoyaError)?.response?.statusCode,
                   500..<600 ~= statusCode {
                    return .just(.failure(NetworkError.server))
                }
                return .just(.failure(err))
            }
    }
}
