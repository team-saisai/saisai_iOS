//
//  HTTPHeaderField.swift
//  SaiSai
//
//  Created by ch on 7/9/25.
//

import Foundation

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}

enum ContentType: String {
    case json = "application/json"
}
