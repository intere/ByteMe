//
//  LocationExtensions.swift
//  ByteMe
//
//  Created by Eric Internicola on 6/6/19.
//  Copyright © 2019 iColasoft. All rights reserved.
//

import CoreLocation
import UIKit

// MARK: - CLLocationCoordinate2D: x / y

public extension CLLocationCoordinate2D {

    /// Converts the longitutude from this point to mercator x value.
    var mercatorX: CLLocationDistance {
        return longitude.radians * Constants.earthRadius
    }

    /// Converts the latitude from this point to a mercator y value.
    var mercatorY: CLLocationDistance {
        return log(tan(.pi / 4 + latitude.radians / 2)) * Constants.earthRadius
    }

    /// Gets you the mercator point for this coordinate.
    var mercatorPoint: CGPoint {
        return CGPoint(x: mercatorX, y: mercatorY)
    }

    /// Converts this to a lat / lon point (where it's x = longitude, y = latitude).
    var latLonPoint: CGPoint {
        return CGPoint(x: longitude, y: latitude)
    }

    fileprivate struct Constants {
        static let earthRadius = 6378137.0
    }
}

// MARK: - CLLocation: x / y
public extension CLLocation {

    /// Gets you the mercatorX location of this point
    var x: Int {
        return Int(coordinate.mercatorX)
    }

    var y: Int {
        return Int(coordinate.mercatorY)
    }

    /// Gets you a random X value that is +/- maxDistance meters away.
    ///
    /// - Parameter maxDistance: The maximum distance in the x direction (in meters).
    /// - Returns: A random number in the appropriate range.
    func randomX(maxDistance: Int) -> Int {
        return Int.random(in: (x - maxDistance)...(x + maxDistance))
    }

    /// Gets you a random Y value that is +/- maxDistance meters away.
    ///
    /// - Parameter maxDistance: The maximum distnace in the y direction (in meters).
    /// - Returns: A random number in the appropriate range.
    func randomY(maxDistance: Int) -> Int {
        return Int.random(in: (y - maxDistance)...(y + maxDistance))
    }

    /// Generates a random position that has a maximum distance in both x and y direction that you specify.
    ///
    /// - Parameter maxDistance: The maximum distance in the x and y directions.
    /// - Returns: The new (random) location that has a maximum of `maxDistance` in either the x or y direction.
    func randomLocation(maxDistance: Int) -> CLLocation {
        return CLLocation(x: randomX(maxDistance: maxDistance), y: randomY(maxDistance: maxDistance), altitude: altitude)
    }

    /// Initializes this location from the provided mercator x, y and altitude.
    ///
    /// - Parameters:
    ///   - x: The mercator x location (in meters).
    ///   - y: The mercator y location (in meters).
    ///   - altitude: The elevation of the point.
    convenience init(x: Int, y: Int, altitude: CLLocationDistance) {
        self.init(coordinate: CLLocationCoordinate2D(latitude: y.mercatorYToLat, longitude: x.mercatorXToLon), altitude: altitude)
    }

}

// MARK: - Int: Degrees / Mercator

extension Int {

    /// Converts this Mercator-X value to Longitudinal Degrees.
    var mercatorXToLon: Double {
        return (Double(self) / CLLocationCoordinate2D.Constants.earthRadius).degrees
    }

    var mercatorYToLat: Double {
        return ((2 * atan(exp(Double(self)/CLLocationCoordinate2D.Constants.earthRadius))) - .pi/2).degrees
    }
}

// MARK: - Radians / Degrees

extension Double {

    /// Convertes these degrees to radians
    var radians: Double {
        return degreesToRadians
    }

    /// Converts these radians to degrees
    var degrees: Double {
        return radiansToDegrees
    }

}
