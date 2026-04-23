//
//  reverseGeocode.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.04.2026.
//


import MapKit

public func reverseGeocode(location: CLLocation) async -> String? {
  guard let request = MKReverseGeocodingRequest(location: location) else { return nil }
  let mapItems = await withCheckedContinuation { continuation in
    request.getMapItems { items, _ in
      nonisolated(unsafe) let result = items
      continuation.resume(returning: result)
    }
  }
  return mapItems?.first?.addressRepresentations?.cityName
}
