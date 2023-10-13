//
//  errors.swift
//  lebaluchon
//
//  Created by Elodie Gage on 13/10/2023.
//

import Foundation
// AppErrors.swift

import Foundation

enum AppError: Error {
    case requestError
    case noDataAvailable
    case parsingFailed
    case apiError
    case httpResponseError
}
