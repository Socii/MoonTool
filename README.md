# MoonTool
A Swift framework containing an astronomical model of the Moon, including properties to obtain the age, percent illuminated, phase, transitions, and other properties of the Moon at a point in time. This is a Swift port of John Walker's `moontool.c`, originally written in 1987.

## Usage
Import the `MoonTool.framework` into your project.

Create an instance of `Moon` at a given `Date`.
```swift
import Foundation
import MoonTool

let now = Date()
let moon = Moon(at: now)

print(String(describing: moon))
// Date: 2021-01-17 14:31:51 +0000
// Phase: Waxing Crescent
// Age: 4.31 days
// Distance: 397623.768516 km
// Illuminated: 19.58 %
// Angular Diameter: 0.500871
// Ecliptic Longitutde: -8.515877
// Ecliptic Latitude: -5.135609
// Parallax: 0.919085

print(moon.phase)
// Waxing Crescent
```

The framework also includes a `JulianDate` object and a `JulianCalendar` model for use in astronomical calculations.
```swift
let now = Date()
let jd = JulianDate(from: now)
print(jd)
// 2459232.1090794797

print(JulianCalendar.Year.days)
// 365.25
