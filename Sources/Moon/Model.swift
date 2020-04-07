// Model.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

// MARK: Model

import Foundation

extension Moon {
  
  /// Inclination of the Moon's orbit.
  static let inclination = 5.145396

  /// Eccentricity of the Moon's orbit.
  static let eccentricity = 0.054900

  /// Moon's angular size at distance a from earth.
  static let angularSize = 0.5181

  /// Semi-mojor axis of the Moon's orbit, in kilometers.
  static let semiMajorAxis = 384401.0
  
  /// Parallax at a distance a from earth.
  static let parallax = 0.9507

  /// Synodic month (new Moon to new Moon), in days.
  static let synodicMonth = 29.53058868

  /// Base date for E. W. Brown's numbered
  /// series of lunations (1923 January 16).
  static let lunationsBase: JulianDay = 2423436.0
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
  
  /// Julian day for 1980 January 0.0.
  static let julianDay: JulianDay = 2444238.5
  
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
