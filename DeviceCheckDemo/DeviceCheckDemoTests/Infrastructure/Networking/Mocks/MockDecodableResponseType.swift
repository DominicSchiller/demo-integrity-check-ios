import Foundation

/// A `Decodable` API response DTO mock.
struct MockDecodableResponseType: Decodable, Equatable {
    let title: String
    let message: String
}
