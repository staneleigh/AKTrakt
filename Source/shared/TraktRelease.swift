//
//  TraktRelease.swift
//  Pods
//
//  Created by Florian Morello on 29/03/16.
//
//

import Foundation

/// Represents a movie release
public struct TraktRelease: CustomStringConvertible {
    /// Country code
    public let countryCode: String
    /// Certification
    public let certification: String
    /// Date
    public let date: NSDate
    /// Type
    public let type: TraktReleaseType
    /// Note
    public let note: String!

    /**
     Init with data

     - parameter data: data
     */
    public init?(data: JSONHash?) {
        guard
            let country = data?["country"] as? String,
            certification = data?["certification"] as? String,
            release_date = data?["release_date"] as? String,
            date = Trakt.dateFormatter.dateFromString(release_date),
            release_type = data?["release_type"] as? String,
            type = TraktReleaseType(rawValue: release_type)
            else {
                return nil
        }

        self.countryCode = country
        self.certification = certification
        self.date = date
        self.type = type
        self.note = data?["note"] as? String
    }

    /// CustomStringConvertible conformance
    public var description: String {
        return "TraktRelease \(countryCode) \(type.rawValue) \(date) \(note) \(certification)"
    }
}
