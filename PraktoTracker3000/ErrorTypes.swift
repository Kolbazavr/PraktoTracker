//
//  ErrorTypes.swift
//  MovieQuizUI
//
//  Created by ANTON ZVERKOV on 12.02.2025.
//

import Foundation

enum PraktoError: Error {
    case invalidURL
    case missingDataError
    case serverError
    case decodingError
}
