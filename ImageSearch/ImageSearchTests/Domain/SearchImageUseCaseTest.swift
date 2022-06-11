//
//  SearchImageUseCaseTest.swift
//  ImageSearchTests
//
//  Created by yongmin lee on 5/1/22.
//

import XCTest
@testable import ImageSearch

class SearchImageUseCaseTest: XCTestCase {

    // system under test
    var sut : ImageUseCase!
    var mockImageRepository : MockImageRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        mockImageRepository = MockImageRepository()
        sut = ImageUseCaseImpl(imageRepository: mockImageRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockImageRepository = nil
    }

    func test_Repository에서_getImages성공하면_이미지_데이터를_가져옵니다()  {
        // given
        mockImageRepository.setGetImages(toFail: false)
        let sampleData = try! JSONDecoder().decode(SearchResponseDTO<ImageAPI.Documents>.self, from: ImageAPI.searchImages(query: "", page: 1).sampleData).documents.map{ item in
            return Image(thumbnail_url: item.thumbnail_url, image_url: item.image_url, width: item.width, height: item.height)
        }
        
        
        // when
        let response = try? sut.execute(query: "", page: 1).toBlocking(timeout: 1).first()
        
        // then
        XCTAssertNotNil(response)
        switch response! {
        case .success(let imageList):
            XCTAssertEqual(imageList.items.count, List<Image>.init(items: sampleData, isEnd: true).items.count)
            break
        case .failure(_):
            XCTFail()
            break
        }
    }
    
    func test_Repository에서_getImages실패하면_네트워크에러를_리턴합니다() {
        // given
        mockImageRepository.setGetImages(toFail: true)
        
        // when
        let response = try? sut.execute(query: "", page: 1).toBlocking(timeout: 1).first()
        
        // then
        XCTAssertNotNil(response)
        switch response! {
        case .success(_):
            XCTFail()
            break
        case .failure(let err):
            XCTAssertEqual(err as! NetworkError, NetworkError.client)
            break
        }
    }


}
