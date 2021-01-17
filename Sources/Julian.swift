// Julian.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Definition

/// A number representing a day plus the fraction of a day
/// in the Julian calendar.
///
/// `JulianDate` is a type of `Double`, so can
/// be created using a literal with type-casting:
/// ```
/// let jd: JulianDate = 245845.5
/// ```
/// Create a `JulianDate` from a `Date`:
/// ```
/// let now = Date()
/// let jd = JulianDate(from: now)
/// ```
/// Get the `Date` from a `JulianDate`:
/// ````
/// let date = jd.date
/// ````
public typealias JulianDate = Double

public extension JulianDate {

  /// Create a `JulianDate` from an instance of `Date`.
  ///
  /// - Parameters:
  ///   - date: The date.
  ///
  init(from date: Date) {
    self = JulianCalendar.julianDate(from: date)
  }
}

// MARK: - Interface

public extension JulianDate {
  
  /// Return an instance of `Date` from the Julian date.
  var date: Date {
    return JulianCalendar.date(from: self)
  }
}

// MARK: - Model

public enum JulianCalendar {
  
  /// Return the Julian date from a date.
  fileprivate static func julianDate(from: Date) -> JulianDate {
    
    return (from.timeIntervalSince1970 - zero.timeIntervalSince1970) / Day.seconds
  }
  
  /// Return the date from a Julian date.
  /// - Parameter from: The Julian date.
  fileprivate static func date(from: JulianDate) -> Date {
    
    // FIXME: Fails test due to rounding error.
    let interval = zero.timeIntervalSince1970
      + ((from - julianDate(from: zero)) * Day.seconds)
    
    return Date(timeIntervalSince1970: interval)
  }

  /// The zero date in the Julian calendar.
  ///
  /// Defined as:
  ///
  /// **UTC 12:00:00 — 01, January, 4712 B.C.**
  ///
  /// in the gregorian calendar.
  ///
  public static let zero: Date = {
    
    let gregorian = Calendar(identifier: .gregorian)
    
    guard let utc = TimeZone(identifier: "UTC")
      else { preconditionFailure("Unable to create timezone") }
    
    let components = DateComponents(calendar: gregorian,
                                    timeZone: utc,
                                    year: -4712,
                                    month: 1,
                                    day: 1,
                                    hour: 12)
    
    guard let date = components.date
      else { preconditionFailure("Unable to create date") }
    
    return date
  }()
  
  /// Properties of a Julian century.
  public enum Century {
    
    /// The number of years in a century.
    public static let years = 100.0
    
    /// The number of days in a century.
    public static let days = Century.years * Year.days
    
    /// The number of hours in a century.
    public static let hours = Century.years * Year.hours
        
    /// The number of minutes in a century.
    public static let minutes = Century.years * Year.minutes
    
    /// The number of seconds in a century.
    public static let seconds: TimeInterval = Century.years * Year.seconds
  }
  
  /// Properties of a Julian year.
  public enum Year {
    
    /// The number of days in a year.
    public static let days = 365.25
    
    /// The number of hours in a year.
    public static let hours = Year.days * 24
    
    /// The number of minutes in a year.
    public static let minutes = Year.hours * 60
    
    /// The number of seconds in a year.
    public static let seconds: TimeInterval = Year.minutes * 60
  }
  
  /// Properties of a Julian day.
  public enum Day {
    
    /// The number of hours in a day.
    public static let hours = 24.0
    
    /// The number of minutes in a day.
    public static let minutes = Day.hours * 60
    
    /// The number of seconds in a day.
    public static let seconds: TimeInterval = Day.minutes * 60
  }
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
