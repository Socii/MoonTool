// Math.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Math

/// Solve the equation of Kepler.
///
/// - Parameters:
///   - m: Mean phase.
///   - ecc: Eccentricity.
///
func kepler(_ m: Double, _ ecc: Double) -> Double {
  
  let epsilon = 1e-6
  let rad = deg2rad(m)
  var e = rad
  
  var check = false
  repeat {
    let delta = e - ecc * sin(e) - rad
    e = e - delta / (1.0 - ecc * cos(e))
    if abs(delta) <= epsilon { check = true }
  } while check == false
  
  return e
}

/// Arc-seconds to degrees
///
/// - Parameter a: Arc-seconds.
///
func aSec(_ a: Double) -> Double {
  
  return a / 3600.0
}

/// Converts degrees to radians.
///
/// - Parameter d: Degrees.
///
func deg2rad(_ d: Double) -> Double {
  
  return d * (.pi / 180)
}

/// Converts radians to degrees.
///
/// - Parameter r: Radians.
///
func rad2deg(_ r: Double) -> Double {
  
  return r / (.pi / 180)
}

/// Range reduces an angle in degrees.
///
/// - Parameter d: Degrees.
///
func fixangle(_ d: Double) -> Double {
  
  return d - 360.0 * (floor(d / 360.0))
}

/// Range reduces an angle in radians.
///
/// - Parameter r: Radians.
///
func fixangr(_ r: Double) -> Double {
  
  return r - (.pi * 2) * (floor(r / (.pi * 2)))
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
