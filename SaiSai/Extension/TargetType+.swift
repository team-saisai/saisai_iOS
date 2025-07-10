//
//  API.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation
import Moya

/// boiler-plate 코드를 줄이기 위한 Moya 공통 baseURL 정의
extension TargetType {
    var baseURL: URL {
        let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
        if let url = URL(string: urlString) {
            return url
        } else {
            print("Failed to make baseURL")
            return URL(filePath: "")
        }
    }
}
