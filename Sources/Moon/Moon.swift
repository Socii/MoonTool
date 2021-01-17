// Moon.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

// An astronomical model of the Moon.
//
// Astronomy code ported from `moontool.c` -
// written by John Walker http://www.fourmilab.ch

import Foundation

// MARK: Definition

/// An astronomical model of the Moon.
///
/// An instance of `Moon` contains position, current phase,
/// percent illuminated, age, and other properties of the
/// Moon at a given point in time.
///
public struct Moon {

  /// The date.
  public let date: Date
  
  /// The completed percentage of the current cycle.
  ///
  /// A full lunar cycle is represented by the range
  /// `0..<1`
  ///
  /// Transitions occur at:
  ///
  /// - `0.00` = **New moon**
  /// - `0.25` = **First quarter**
  /// - `0.50` = **Full moon**
  /// - `0.75` = **Second quarter**
  ///
  /// Phases are in the ranges:
  ///
  /// - `0.00..<0.25` = **Waxing crescent**
  /// - `0.25..<0.50` = **Waxing gibbous**
  /// - `0.50..<0.75` = **Waning gibbous**
  /// - `0.75..<1.00` = **Waning crescent**
  public let cycleIndex: Double
    
  /// The percentage of the moon illuminated by the sun.
  public let illuminated: Double
  
  /// The number of days passed since the previous new moon.
  public let age: Double
  
  /// The geocentric distance to the earth, in kilometers.
  public let distance: Double
  
  /// The angular diameter, in kilometers.
  public let angularDiameter: Double
  
  /// The ecliptic longitute, in kilometers.
  public let eclipticLongitute: Double
  
  /// The ecliptic latitude, in kilometers.
  public let eclipticLatitude: Double
  
  /// The moons parallax.
  public let parallax: Double
  
  /// The suns geocentrice distance to the earth,
  /// in kilometers.
  public let sunDistance: Double
  
  /// The suns angular diameter, in kilometers.
  public let sunAngularDiameter: Double
  
  /// Create an instance of `Moon` at a given date.
  ///
  /// - Parameter at: The date.
  ///
  public init(at date: Date) {
    self.date = date
    let calculated = Moon.initialCalculations(for: date)
    cycleIndex = calculated.cycleIndex
    illuminated = calculated.illuminated
    age = calculated.age
    distance = calculated.distance
    angularDiameter = calculated.angularDiameter
    eclipticLongitute = calculated.eclipticLongitute
    eclipticLatitude = calculated.eclipticLatitude
    parallax = calculated.parallax
    sunDistance = calculated.sunDistance
    sunAngularDiameter = calculated.sunAngularDiameter
  }
  
  /// Create an instance of `Moon` at a given Julian Date.
  ///
  /// - Parameter at: The Julian Date.
  ///
  public init(at julianDate: JulianDate) {
    self.date = julianDate.date
    let calculated = Moon.initialCalculations(for: date)
    cycleIndex = calculated.cycleIndex
    illuminated = calculated.illuminated
    age = calculated.age
    distance = calculated.distance
    angularDiameter = calculated.angularDiameter
    eclipticLongitute = calculated.eclipticLongitute
    eclipticLatitude = calculated.eclipticLatitude
    parallax = calculated.parallax
    sunDistance = calculated.sunDistance
    sunAngularDiameter = calculated.sunAngularDiameter
  }
}

// MARK: - Custom String Convertable

extension Moon: CustomStringConvertible {
  
  public var description: String {
    var string = ""
    string.append("Date: \(date)\n")
    string.append("Phase: \(phase)\n")
    string.append("Age: \(age.rounded(to: 2)) days\n")
    string.append("Distance: \(distance.rounded(to: 6)) km\n")
    string.append("Illuminated: \(illuminated.rounded(to: 2)) %\n")
    string.append("Angular Diameter: \(angularDiameter.rounded(to: 6))\n")
    string.append("Ecliptic Longitutde: \(eclipticLongitute.rounded(to: 6))\n")
    string.append("Ecliptic Latitude: \(eclipticLatitude.rounded(to: 6))\n")
    string.append("Parallax: \(parallax.rounded(to: 6))\n")
    return string
  }
}

// MARK: - Model

extension Moon {
  
  /// A tuple containing the properties of the moon.
  ///
  private typealias Calculated = (cycleIndex: Double,
                                  illuminated: Double,
                                  age: Double,
                                  distance: Double,
                                  angularDiameter: Double,
                                  eclipticLongitute: Double,
                                  eclipticLatitude: Double,
                                  parallax: Double,
                                  sunDistance: Double,
                                  sunAngularDiameter: Double)
  
  /// Calculate the properties of the moon for a given date.
  ///
  /// - Parameter date: The date.
  ///
  private static func initialCalculations(for date: Date) -> Calculated {
    
    // Calculation of the Sun's position
    
    let jd = JulianDate(from: date) - Epoch1980.julianDate
    
    // Mean anomaly of the Sun
    let N = fixangle((360 / 365.2422) * jd)
    
    // Convert from perigee coordinates to epoch 1980
    let M = fixangle(N + Epoch1980.Sun.eclipticLongitude - Sun.eclipticLongitudeAtPerigee)
    
    // Solve Kepler's equation
    var Ec = kepler(M, Moon.eccentricity)
    Ec = sqrt((1 + Moon.eccentricity) / (1 - Moon.eccentricity)) * tan(Ec / 2.0)
    
    // True anomaly
    Ec = 2 * rad2deg(atan(Ec))
    
    // Suns's geometric ecliptic longuitude
    let lambda_sun = fixangle(Ec + Sun.eclipticLongitudeAtPerigee)
    
    // Orbital distance factor
    let F = ((1 + Moon.eccentricity * cos(deg2rad(Ec))) / (1 - pow(Moon.eccentricity, 2)))
    
    // Distance to Sun in km
    let sun_dist = Sun.semiMajorAxis / F
    let sun_angular_diameter = F * Sun.angularSizeAtSemiMajorAxis

    // Calculation of the Moon's position
    
    // Moon's mean longitude
    let moon_longitude = fixangle(13.1763966 * jd + Epoch1980.Moon.meanLongitude)

    // Moon's mean anomaly
    let MM = fixangle(moon_longitude - 0.1114041 * jd - Epoch1980.Moon.meanPerigee)

    // Moon's ascending node mean longitude
    let MN = fixangle(Epoch1980.Moon.nodeMeanLongitude - 0.0529539 * jd)
    
    let evection = 1.2739 * sin(deg2rad(2 * (moon_longitude - lambda_sun) - MM))

    // Annual equation
    let annual_eq = 0.1858 * sin(deg2rad(M))

    // Correction term
    let A3 = 0.37 * sin(deg2rad(M))

    let MmP = MM + evection - annual_eq - A3

    // Correction for the equation of the centre
    let mEc = 6.2886 * sin(deg2rad(MmP))

    // Another correction term
    let A4 = 0.214 * sin(deg2rad(2 * MmP))

    // Corrected longitude
    let lP = moon_longitude + evection + mEc - annual_eq + A4

    // Variation
    let variation = 0.6583 * sin(deg2rad(2 * (lP - lambda_sun)))

    // True longitude
    let lPP = lP + variation

    // Calculation of the Moon's inclination
    // unused for phase calculation.
    
    // Corrected longitude of the node
    let NP = MN - 0.16 * sin(deg2rad(M))
    
    // Y inclination coordinate
    let y = sin(deg2rad(lPP - NP)) * cos(deg2rad(Moon.inclination))
    
    // X inclination coordinate
    let x = cos(deg2rad(lPP - NP))
    
    // Ecliptic longitude (unused?)
    let lambda_moon = rad2deg(atan2(y,x)) + NP
    
    // Ecliptic latitude (unused?)
    let BetaM = rad2deg(asin(sin(deg2rad(lPP - NP)) * sin(deg2rad(Moon.inclination))))
    
    // Calculation of the phase of the Moon
    
    // Age of the Moon, in degrees
    let moon_age = lPP - lambda_sun

    // Phase of the Moon
    let moon_phase = (1 - cos(deg2rad(moon_age))) / 2.0

    // Calculate distance of Moon from the
    // centre of the Earth
    let moon_dist = (Moon.semiMajorAxis * (1 - pow(Moon.eccentricity, 2))) / (1 + Moon.eccentricity * cos(deg2rad(MmP + mEc)))

    // Calculate Moon's angular diameter
    let moon_diam_frac = moon_dist / Moon.semiMajorAxis

    let moon_angular_diameter = Moon.angularSize / moon_diam_frac

    // Calculate Moon's parallax (unused?)
    let moon_parallax = Moon.parallax / moon_diam_frac
    
    return Calculated(cycleIndex: fixangle(moon_age) / 360.0,
                      illuminated: moon_phase * 100,
                      age: Moon.synodicMonth * fixangle(moon_age) / 360.0,
                      distance: moon_dist,
                      angularDiameter: moon_angular_diameter,
                      eclipticLongitute: lambda_moon,
                      eclipticLatitude: BetaM,
                      parallax: moon_parallax,
                      sunDistance: sun_dist,
                      sunAngularDiameter: sun_angular_diameter)
  }
  
  /// Inclination of the Moon's orbit.
  static let inclination = 5.145396

  /// Eccentricity of the Moon's orbit.
  static let eccentricity = 0.054900

  /// Moon's angular size at distance a from earth.
  static let angularSize = 0.5181

  /// Semi-major axis of the Moon's orbit, in kilometers.
  static let semiMajorAxis = 384401.0
  
  /// Parallax at a distance from earth.
  static let parallax = 0.9507

  /// Synodic month (New Moon to New Moon), in days.
  static let synodicMonth = 29.53058868

  /// Base date for E. W. Brown's numbered
  /// series of lunations (1923 January 16).
  static let lunationsBase: JulianDate = 2423436.0
}

/// Properties of the sun.
enum Sun {
 
  /// Ecliptic longitude of the Sun at perigee.
  static let eclipticLongitudeAtPerigee = 282.596403
  
  /// Semi-major axis of Sun's orbit, in kilometers.
  static let semiMajorAxis = 1.49585e8
  
  /// Sun's angular size, in degrees, at semi-major axis distance.
  static let angularSizeAtSemiMajorAxis = 0.533128
}

/// Properties of the Earth.
enum Earth {
  
  /// The radius of the Earth, in kilometers.
  static let radius = 6378.16
  
  /// Eccentricity of Earth's orbit.
  static let eccentricity = 0.016718
}

/// Orbit elements for epoch 1980.0
enum Epoch1980 {
  
  /// Julian date for 1980 January 0.0.
  static let julianDate: JulianDate = 2444238.5
  
  enum Sun {
    
    /// Ecliptic longitude of the Sun at epoch.
    static let eclipticLongitude = 278.833540
  }
  
  enum Moon {
    
    /// Moon's mean longitude at the epoch.
    static let meanLongitude = 64.975464
    
    /// Mean longitude of the perigee at the epoch.
    static let meanPerigee = 349.383063
    
    /// Mean longitude of the node at the epoch.
    static let nodeMeanLongitude = 151.950429
  }
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
