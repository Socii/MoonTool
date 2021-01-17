// Moon+Phase.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Interface

extension Moon {
  
  /// The current phase of the moon.
  public var phase: Phase {
    return Moon.Phase.at(cycleIndex)
  }
}

// MARK: - Model

extension Moon {
  
  /// Calculates time of the mean new Moon
  /// for a given base date.
  ///
  /// This argument K to this function is the
  /// precomputed synodic month index, given by:
  /// ```
  /// K = (year - 1900) * 12.3685
  /// ```
  /// where `year` is expressed as a year
  /// and fractional year.
  ///
  static func meanPhase(at date: JulianDate, k: Double) -> JulianDate {

    // Time in Julian centuries from 1900 January 0.5
    let t = (date - JulianDate(from: Date.jan1900))
            / JulianCalendar.Century.days
    
    // square
    let t2 = t * t
    // and cube
    let t3 = t2 * t
    
    return 2415020.75933
      + Moon.synodicMonth * k
      + 0.0001178 * t2
      - 0.000000155 * t3
      + 0.00033 * sin(deg2rad(166.56 + 132.87 * t - 0.009173 * t2))
  }
  
  static func truePhase(_ meanPhase: Double, transtition: Transition) -> JulianDate {

    // Add phase to new moon time
    // Time in Julian centuries from 1900 January 0.5
    let phase = transtition.index
    let k = meanPhase + phase
    let t = k / 1236.85
    let t2 = t * t
    let t3 = t2 * t
    
    // Mean time of phase
    var pt = 2415020.75933
      + Moon.synodicMonth * k
      + 0.0001178 * t2
      - 0.000000155 * t3
      + 0.00033 * sin(deg2rad(166.56 + 132.87 * t - 0.009173 * t2 ))
    
    let m = 359.2242
      + 29.10535608 * k
      - 0.0000333 * t2
      - 0.00000347 * t3
    
    let mprime = 306.0253
      + 385.81691806 * k
      + 0.0107306 * t2
      + 0.00001236 * t3
      
    // Moon’s argument of latitude
    let f = 21.2964
      + 390.67050646 * k
      - 0.0016528 * t2
      - 0.00000239 * t3
    
    // Corrections for New and Full Moon
    if ((phase < 0.01) || (abs(phase - 0.5) < 0.01)) {
      pt += (0.1734 - 0.000393 * t) * sin(deg2rad(m))
        + 0.0021 * sin(deg2rad(2 * m))
        - 0.4068 * sin(deg2rad(mprime))
        + 0.0161 * sin(deg2rad(2 * mprime))
        - 0.0004 * sin(deg2rad(3 * mprime))
        + 0.0104 * sin(deg2rad(2 * f))
        - 0.0051 * sin(deg2rad(m + mprime))
        - 0.0074 * sin(deg2rad(m - mprime))
        + 0.0004 * sin(deg2rad(2 * f + m))
        - 0.0004 * sin(deg2rad(2 * f - m))
        - 0.0006 * sin(deg2rad(2 * f + mprime))
        + 0.0010 * sin(deg2rad(2 * f - mprime))
        + 0.0005 * sin(deg2rad(m + 2 * mprime))
    } else if ((abs(phase - 0.25) < 0.01 || (abs(phase - 0.75) < 0.01))) {
      pt += (0.1721 - 0.0004 * t) * sin(deg2rad(m))
        + 0.0021 * sin(deg2rad(2 * m))
        - 0.6280 * sin(deg2rad(mprime))
        + 0.0089 * sin(deg2rad(2 * mprime))
        - 0.0004 * sin(deg2rad(3 * mprime))
        + 0.0079 * sin(deg2rad(2 * f))
        - 0.0119 * sin(deg2rad(m + mprime))
        - 0.0047 * sin(deg2rad(m - mprime))
        + 0.0003 * sin(deg2rad(2 * f + m))
        - 0.0004 * sin(deg2rad(2 * f - m))
        - 0.0006 * sin(deg2rad(2 * f + mprime))
        + 0.0021 * sin(deg2rad(2 * f - mprime))
        + 0.0003 * sin(deg2rad(m + 2 * mprime))
        + 0.0004 * sin(deg2rad(m - 2 * mprime))
        - 0.0003 * sin(deg2rad(2 * m + mprime))
    }
    
    // First quarter correction
    if (phase < 0.5) {
    pt += 0.0028
      - 0.0004 * cos(deg2rad(m))
      + 0.0003 * cos(deg2rad(mprime))
    } else {
    // Last quarter correction
    pt += -0.0028
      + 0.0004 * cos(deg2rad(m))
      - 0.0003 * cos(deg2rad(mprime))
    }
    
    return pt
  }
}

// MARK: - Phase Definition

extension Moon {
    
  /// The four phases of a lunar cycle:
  /// **Waxing Crescent, Waxing Gibbous,
  /// Waning Gibbous,** and **Waning Crescent.**
  public enum Phase {
    /// Waxing Crescent.
    case waxingCrescent
    /// Waxing Gibbous.
    case waxingGibbous
    /// Waning Gibbous.
    case waningGibbous
    /// Waning Crescent.
    case waningCrescent
  }
}

// MARK: - Phase Custom String Convertable

extension Moon.Phase: CustomStringConvertible {
  
  public var description: String {
    switch self {
    case .waxingCrescent: return "Waxing Crescent"
    case .waxingGibbous: return "Waxing Gibbous"
    case .waningGibbous: return "Waning Gibbous"
    case .waningCrescent: return "Waning Crescent"
    }
  }
}

// MARK: - Phase Interface

extension Moon.Phase {
  
  /// The range of the phase in the lunar cycle.
  var range: Range<Double> {
    switch self {
    case .waxingCrescent: return 0..<0.25
    case .waxingGibbous: return 0.25..<0.5
    case .waningGibbous: return 0.5..<0.75
    case .waningCrescent: return 0.75..<1
    }
  }
}

// MARK: - Phase Model

extension Moon.Phase {
  
  /// Returns the `Phase` at the guven point in the
  /// lunar cycle.
  ///
  /// - Precondition: `index` must be in the range `0..<1`
  /// - Parameter index: The index in the lunar cycle.
  ///
  static func at(_ index: Double) -> Self {
    switch index {
    case 0.00..<0.25: return .waxingCrescent
    case 0.25..<0.50: return .waxingGibbous
    case 0.50..<0.75: return .waningGibbous
    case 0.75..<1.00: return .waxingGibbous
    default: preconditionFailure("Phase must be in the range 0..<1")
    }
  }
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
