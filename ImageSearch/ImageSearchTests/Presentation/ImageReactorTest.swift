//
//  ImageReactorTest.swift
//  ImageSearchTests
//
//  Created by yongmin lee on 5/2/22.
//

import Foundation
import Nimble
import Quick
import RxBlocking
import Moya
import XCTest
import ReactorKit

@testable import ImageSearch

class ImageReactorTest: QuickSpec {

    override func spec() {
        
        // given
        describe("성공케이스를 반환하는 usecase가 주입된 reactor에") {
            
            var mockSearchImageUseCase : MockImageUseCase!
            var reactor : SearchImageReactor!
            
            beforeEach {
                mockSearchImageUseCase = MockImageUseCase()
                mockSearchImageUseCase.setExecute(toFail: false)
                reactor = SearchImageReactor(searchImageUseCase: mockSearchImageUseCase)
            }
            
            // when
            context("inputQuery 액션이 발생하면") {
                beforeEach {
                    reactor.action.onNext(.inputQuery("test"))
                }
                
                // then
                it("state의 query가 입력된 텍스트로 바뀐다") {
                    expect(reactor.currentState.query).to(equal("test"))
                }
                
                // then
                it("첫번째 이미지 페이지를 fetch한다"){
                    let sampleData = try! JSONDecoder().decode(SearchResponseDTO<ImageAPI.Documents>.self, from: ImageAPI.searchImages(query: "", page: 1).sampleData).documents.map{ item in
                        return Image(thumbnail_url: item.thumbnail_url, image_url: item.image_url, width: item.width, height: item.height)
                    }
                    let expected : [ImageListSection] = [.init(images: sampleData)]
                    
                    expect(reactor.currentState.imageSection).to(equal(expected))
                    expect(reactor.currentState.page).to(equal(1))
                }
            }

            // when
            context("loadMore 액션이 발생하면") {
                beforeEach {
                    reactor.action.onNext(.inputQuery("test"))
                    reactor.action.onNext(.loadMore)
                }
                
                // then
                it("state의 page가 증가한다") {
                    expect(reactor.currentState.page).to(equal(2))
                }
                
                // then
                it("다음 이미지 페이지를 fetch한다") {
                    let sampleData = try! JSONDecoder().decode(SearchResponseDTO<ImageAPI.Documents>.self, from: ImageAPI.searchImages(query: "", page: 1).sampleData).documents.map{ item in
                        return Image(thumbnail_url: item.thumbnail_url, image_url: item.image_url, width: item.width, height: item.height)
                    }
                    let expected : [ImageListSection] = [.init(images: sampleData)]
                    expect(reactor.currentState.imageSection).notTo(equal(expected))
                }
            }
            
        }
        
        // given
        describe("실패케이스를 반환하는 usecase가 주입된 reactor에") {

            var mockSearchImageUseCase : MockImageUseCase!
            var reactor : SearchImageReactor!

            beforeEach {
                mockSearchImageUseCase = MockImageUseCase()
                mockSearchImageUseCase.setExecute(toFail: true)
                reactor = SearchImageReactor(searchImageUseCase: mockSearchImageUseCase)
            }

            // when
            context("inputQuery 액션이 발생하면") {

                beforeEach {
                    reactor.action.onNext(.inputQuery("test"))
                }
                
                // then
                it("state의 errResult에 에러가 할당된다") {
                    expect(reactor.currentState.errResult).notTo(beNil())
                }
            }

            // when
            context("loadMore 액션이 발생하면") {

                beforeEach {
                    reactor.action.onNext(.inputQuery("test"))
                    reactor.action.onNext(.loadMore)
                }
                
                // then
                it("state의 errResult에 에러가 할당된다") {
                    expect(reactor.currentState.errResult).notTo(beNil())
                }
            }

        }
    }
}
