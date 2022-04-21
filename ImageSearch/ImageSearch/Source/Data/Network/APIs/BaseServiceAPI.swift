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
}
