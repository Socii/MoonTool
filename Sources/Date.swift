// Date.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Date Extension

public extension Date {
  
  /// Returns the current date adjusted for daylight saving.
  var adjusted: Date {
    return addingTimeInterval(TimeZone.current.daylightSavingTimeOffset())
  }
  
  static var currentUTC: Date {
    return Date().adjusted
  }
  
  /// 1900 January, 12:00 noon.
  static let jan1900: Date = {
    
    let gregorian = Calendar(identifier: .gregorian)
    
    guard let timezone = TimeZone(identifier: "UTC")
      else { preconditionFailure("Unable to create timezone") }
    
    let components = DateComponents(calendar: gregorian,
                                    timeZone: timezone,
                                    year: 1900,
                                    month: 1,
                                    day: 0,
                                    hour: 12,
                                    minute: 0,
                                    second: 0)
    
    guard let date = components.date
      else { preconditionFailure("Unable to create date") }
    
    return date
  }()
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
