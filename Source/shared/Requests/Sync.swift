//
//  Sync.swift
//  Pods
//
//  Created by Florian Morello on 26/05/16.
//
//

import Foundation
import Alamofire

public class TraktRequestGetMovieCollection: TraktRequest {
    public init(extended: TraktRequestExtendedOptions = .Min) {
        super.init(path: "/sync/collection/movies", params: extended.value(), oAuth: true)
    }

    public func request(trakt: Trakt, completion: ([TraktMovie]?, NSError?) -> Void) -> Request? {
        return trakt.request(self) { response in
            guard let entries = response.result.value as? [JSONHash] else {
                return completion(nil, response.result.error)
            }

            let list: [TraktMovie] = entries.flatMap {
                guard let date = $0["collected_at"] as? String,
                    collectedAt = Trakt.datetimeFormatter.dateFromString(date),
                    media = TraktMovie(data: $0["movie"] as? JSONHash) else {
                        return nil
                }
                media.collectedAt = collectedAt
                return media
            }
            completion(list, nil)
        }
    }
}

public class TraktRequestGetShowCollection: TraktRequest {
    public init(extended: TraktRequestExtendedOptions = .Min) {
        super.init(path: "/sync/collection/shows", params: extended.value(), oAuth: true)
    }

    public func request(trakt: Trakt, completion: ([TraktShow]?, NSError?) -> Void) -> Request? {
        return trakt.request(self) { response in
            guard let entries = response.result.value as? [JSONHash] else {
                return completion(nil, response.result.error)
            }
            completion(entries.flatMap {
                guard let show = TraktShow(data: $0["show"] as? JSONHash),
                    seasonsData = $0["seasons"] as? [JSONHash] else {
                        return nil
                }
                show.seasons = seasonsData.flatMap {
                    TraktSeason(data: $0)
                }
                return show
            }, nil)
        }
    }
}
