// Julian.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Definition

/// A number representing a day in the
/// Julian calendar.
///
/// `JulianDay` is a type of `Double`, so can
/// be created using a literal with type-casting:
/// ```
/// let jd: JulianDay = 245845.5
/// ```
/// Create a Julian day from a date:
/// ```
/// let now = Date()
/// let jd = JulianDay(from: now)
/// ```
/// Convert a Julian day to a date:
/// ````
/// let date = jd.date
/// ````
public typealias JulianDay = Double
public extension JulianDay {
  
  /// Return the date of the Julian day.
  var date: Date {
    return JulianCalendar.date(from: self)
  }
  
  /// Create a Julian day from a date.
  init(from date: Date) {
    self = JulianCalendar.day(from: date)
  }
}

// MARK: - Interface

enum JulianCalendar {

  /// Return the Julian day from a date.
  fileprivate static func day(from: Date) -> JulianDay {
    return (from.timeIntervalSince1970 - zero.timeIntervalSince1970) / Day.seconds
  }
  
  /// Return the date from a Julian day.
  /// - Parameter from: The Julian day.
  fileprivate static func date(from: JulianDay) -> Date {
    
    // FIXME: Fails test due to rounding error.
    let interval = zero.timeIntervalSince1970
      + ((from - day(from: zero)) * Day.seconds)
    return Date(timeIntervalSince1970: interval)
  }
}

// MARK: - Model

extension JulianCalendar {
  
  /// The zero date in the Julian calendar.
  ///
  /// Defined as:
  ///
  /// **UTC 12:00:00 — 01, January, 4712 B.C.**
  ///
  /// in the gregorian calendar.
  fileprivate static let zero: Date = {
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
    static let years = 100.0
    
    /// The number of days in a century.
    static var days: Double {
      return Century.years * Year.days
    }
    
    /// The number of hours in a century.
    static var hours: Double {
      return Century.years * Year.hours
    }
    
    /// The number of minutes in a century.
    static var minutes: Double {
      return Century.years * Year.minutes
    }
    
    /// The number of seconds in a century.
    static var seconds: TimeInterval {
      return Century.years * Year.seconds
    }
  }
  
  /// Properties of a Julian year.
  public enum Year {
    
    /// The number of days in a year.
    static let days = 365.25
    
    /// The number of hours in a year.
    static let hours = Year.days * 24
    
    /// The number of minutes in a year.
    static let minutes = Year.hours * 60
    
    /// The number of seconds in a year.
    static let seconds = Year.minutes * 60
  }
  
  /// Properties of a Julian day.
  public enum Day {
    
    /// The number of hours in a day.
    static let hours = 24.0
    
    /// The number of minutes in a day.
    static let minutes = Day.hours * 60
    
    /// The number of seconds in a day.
    static let seconds = Day.minutes * 60
  }
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
