//
//  NetworkTest.swift
//  ImageSearchTests
//
//  Created by yongmin lee on 5/1/22.
//

import Foundation
import Nimble
import Quick
import RxBlocking
import Moya
import XCTest

@testable import ImageSearch

class NetworkServiceTest: QuickSpec {

    override func spec() {
        
        // given
        describe("네트워크 정상") {
            var stubNetwork : NetworkServiceType!
            var result : Result<SearchResponse<ImageAPI.Documents>, Error>!
            
            // when 1
            context("200 이미지 검색 결과 정상이면") {
                beforeEach {
                    stubNetwork = NetworkService(isStub: true)
                    result = try? stubNetwork.request(api: ImageAPI.searchImages(query: "", page: 1)).toBlocking(timeout: 1).first()
                }
                
                // then 1
                it("이미지 리스트 데이터를 받는다") {
                    let expectDummy = ImageAPI.searchImages(query: "", page: 1).sampleData
                    let decodedExpect = try! JSONDecoder().decode(SearchResponse<ImageAPI.Documents>.self, from: expectDummy)
                    
                    _ = result.map { res in
                        switch res {
                        case .success(let response):
                            expect(response.documents).to(equal(decodedExpect.documents))
                            break
                        case .failure(_):
                            XCTFail()
                            break
                        }
                    }
                }
            }
            
            // when 2
            context("400 이미지 검색 에러이면") {
                beforeEach {
                    stubNetwork = NetworkService(isStub: true, sampleStatusCode: 404)
                    result = try! stubNetwork.request(api: ImageAPI.searchImages(query: "", page: 1)).toBlocking(timeout: 1).first()
                }
                
                // then 2
                it("NetworkError.client를 던진다") {
                    _ = result.map { res in
                        switch res {
                        case .success(_):
                            XCTFail()
                            break
                        case .failure(let error):
                            expect(error.localizedDescription).to(equal(NetworkError.client.localizedDescription))
                            break
                        }
                    }
                }
            }
            
            // when 3
            context("500 이미지 검색 에러이면") {
                beforeEach {
                    stubNetwork = NetworkService(isStub: true, sampleStatusCode: 500)
                    result = try! stubNetwork.request(api: ImageAPI.searchImages(query: "", page: 1)).toBlocking(timeout: 1).first()
                }
                
                // then 3
                it("NetworkError.server를 던진다") {
                    _ = result.map { res in
                        switch res {
                        case .success(_):
                            XCTFail()
                            break
                        case .failure(let error):
                            expect(error.localizedDescription).to(equal(NetworkError.server.localizedDescription))
                            break
                        }
                    }
                }
            }
        }
    }
}
