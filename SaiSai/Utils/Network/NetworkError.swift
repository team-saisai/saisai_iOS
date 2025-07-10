//
//  NetworkError.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequestBody
    case invalidHTTPResponse
    case badRequest
    case serverError
    case tokenError
    case reissue
    case versionUpdate
    case unauthroized
}
