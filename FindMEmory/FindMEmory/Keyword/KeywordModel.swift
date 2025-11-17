//
//  KeywordModel.swift
//  FindMEmory
//
//  Created by 권예원 on 11/17/25.
//

import Foundation
nonisolated
struct CreateKeywordResponse: Codable {
    let success: Bool
    let message: String?
    let keyword_id: Int?
    let error: String?
}

nonisolated
struct KeywordModel: Codable, Identifiable {
    let id: Int
    let name: String
    let created_at: String
}

nonisolated
struct KeywordListResponse: Codable {
    let success: Bool
    let keywords: [KeywordModel]
}
