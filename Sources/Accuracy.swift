// Accuracy.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Tolerances & Rounding

enum Tolerance {
  static func decimalPlaces(_ places: Int) -> Double {
    return 1.0 / pow(10, Double(places))
  }
}

// Infix operator for approximately equal to.
infix operator ≈≈

// Approximation operators.

extension FloatingPoint {
  
  static func ≈≈ (lhs: Self, rhs: Self) -> Bool {
    //    logln("\(lhs.self) \(rhs.self)\n\(lhs) - \(rhs) = \(lhs - rhs)")
    return abs(lhs - rhs) < Tolerance.decimalPlaces(9) as! Self
  }
}

extension Double {
  
  /// Return a `Double` rounded to the specified
  /// number of decimal places.
  /// - Parameters:
  ///   - to: The number of decimal places.
  func round(to: Int) -> Double {
    let multiplier = pow(10, Double(to))
    return Darwin.round(self * multiplier) / multiplier
  }
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
