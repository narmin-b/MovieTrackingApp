//
//  GuestSessionDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 15.01.25.
//

import Foundation

struct GuestSessionDTO: Codable {
    let success: Bool
    let guestSessionID, expiresAt: String

    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}

extension GuestSessionDTO {
    func mapToDomain() -> GuestSessionProtocol {
        .init(success: success,
              guestSessionID: guestSessionID,
              expiresAt: expiresAt)
    }
}
