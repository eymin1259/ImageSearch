//
//  BaseServiceAPI.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/20/22.
//

import Foundation
import Moya

protocol BaseServiceAPI: TargetType {
    associatedtype Documents: Codable
    var baseURL: URL { get }
    var headers: [String : String]? { get }
    var path: String { get }
    var method: Moya.Method { get }
    var task: Task { get }
    var sampleData: Data { get }
}

extension BaseServiceAPI {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json;charset=UTF-8",
            "Authorization" : "KakaoAK \(NetworkService.API_KEY)"
        ]
    }
}
