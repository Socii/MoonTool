// JulianTests.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import XCTest
@testable import MoonTool

class JulianTests: XCTestCase {
      
//  func testEpochs() {
//    XCTAssertEqual(Julian.Epoch.J1970.rawValue, 2440587.5)
//    XCTAssertEqual(Julian.Epoch.J2000.rawValue, 2451544.5)
//  }
  
  func testDateToJulianDate() {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let timeZone = TimeZone(secondsFromGMT: 0)
    
    XCTAssertNotNil(timeZone)
    
    let gregorian = Calendar(identifier: .gregorian)
    
    var tests = [(Date?, Double)]()
    
    // Test dates taken from https://planetcalc.com.
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1966, month: 8, day: 18, hour: 0, minute: 0, second: 0).date, 2439355.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 2000, month: 1, day: 1, hour: 12, minute: 0, second: 0).date, 2451545.0))
    
    
    // Data taken from Astronomical Algorithms, Chapter 7, Page 62.
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 2000, month: 1, day: 1, hour: 12, minute: 0, second: 0).date, 2451545.0))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1999, month: 1, day: 1, hour: 0, minute: 0, second: 0).date, 2451179.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1987, month: 1, day: 27, hour: 0, minute: 0, second: 0).date, 2446822.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1987, month: 6, day: 19, hour: 12, minute: 0, second: 0).date, 2446966.0))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1988, month: 1, day: 27, hour: 0, minute: 0, second: 0).date, 2447187.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1988, month: 6, day: 19, hour: 12, minute: 0, second: 0).date, 2447332.0))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1900, month: 1, day: 1, hour: 0, minute: 0, second: 0).date, 2415020.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1600, month: 1, day: 1, hour: 0, minute: 0, second: 0).date, 2305447.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 1600, month: 12, day: 31, hour: 0, minute: 0, second: 0).date, 2305812.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: 837, month: 4, day: 10, hour: 7, minute: 12, second: 0).date, 2026871.8))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: -123, month: 12, day: 31, hour: 0, minute: 0, second: 0).date, 1676496.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: -122, month: 1, day: 1, hour: 0, minute: 0, second: 0).date, 1676497.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: -1000, month: 7, day: 12, hour: 12, minute: 0, second: 0).date, 1356001.0))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: -1000, month: 2, day: 29, hour: 0, minute: 0, second: 0).date, 1355866.5))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: -1001, month: 8, day: 17, hour: 21, minute: 36, second: 0).date, 1355671.4))
    
    tests.append((DateComponents(calendar: gregorian, timeZone: timeZone!, year: -4712, month: 1, day: 1, hour: 12, minute: 0, second: 0).date, 0.0))
    
    for (date, result) in tests {
      XCTAssertNotNil(date)
      let julianDate = JulianDay(from: date!)
//      logln("Date: \(date)\nExpected:   \(result)\nJulian.day: \(julianDate)\nDifference: \(abs(result - julianDate))")
      XCTAssertEqual(julianDate, result)
    }
  }
}
