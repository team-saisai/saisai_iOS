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
    case refreshToken = "Refresh-Token"
    case acceptType = "Accept"
    case accessToken = "accessToken"
}

enum ContentType: String {
    case json = "application/json"
}
