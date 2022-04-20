//
//  ImageAPI.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/20/22.
//

import Foundation
import Moya

enum ImageAPI {
    case searchImages(query:String, page:Int)
}

extension ImageAPI : TargetType {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
    
    var path: String {
        switch self {
        case .searchImages(_,_) :
            return "/v2/search/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchImages(_,_) :
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchImages(let query, let page):
            let params: [String: Any] = [
                "query": query,
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json;charset=UTF-8",
            "Authorization" : "KakaoAK \(NetworkService.API_KEY)"
        ]
    }
    
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "Mock", ofType: "json") ?? ""
        let jsonString = try? String(contentsOfFile: path)
        return jsonString!.data(using: .utf8)!
    }
    
}
