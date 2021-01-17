// Moon+Transition.swift

// Copyright © 2019 Socii. All rights reserved.
// MIT License @ end of file.

import Foundation

// MARK: Interface

public extension Moon {
  
  /// The transitions in the current lunar cycle.
  var transitions: Transitions {
    return Moon.transitions(for: date)
  }
  
  /// The upcoming transitions in the current
  /// lunar cycle.
  var nextTransitions: Transitions {
    var next = transitions
    next.removeAll { $0.date < date }
    return next
  }

  /// The next transition in the current
  /// lunar cycle.
  var nextTransition: TransitionDate {
    return nextTransitions.first!
  }
}

// MARK: - Model

public extension Moon {
  
  /// The transitions in a lunar cycle for a given date.
  ///
  /// - Parameter date: The date.
  ///
  static func transitions(for date: Date) -> Transitions {
    
    let gregorian = Calendar(identifier: .gregorian)
    
    guard let startDate = gregorian.date(byAdding: .day, value: -45, to: date)
      else { preconditionFailure("Unable to create start date") }
    
    let components = gregorian.dateComponents([.year, .month], from: startDate)
    
    guard let year = components.year
      else { preconditionFailure("Unable to retrive year") }
    
    guard let month = components.month
      else { preconditionFailure("Unable to retrive month") }
    
    let day = JulianDate(from: date)
    
    var k1 = floor((Double(year) + ((Double(month) - 1) * (1.0 / 12.0)) - 1900) * 12.3685)
    
    var nt1 = meanPhase(at: day, k: k1)
    var adate = nt1

    var k2 = 0.0
    var nt2 = 0.0
    let test = true
    while test == true {
      adate += Moon.synodicMonth
      k2 = k1 + 1
      nt2 = meanPhase(at: adate, k: k2)
      if nt1 <= day && day < nt2 { break }
      nt1 = nt2
      k1 = k2
    }

    var transitions: Transitions = []
    transitions.append(Transition.trueDate(k1, .new))
    transitions.append(Transition.trueDate(k1, .first))
    transitions.append(Transition.trueDate(k1, .full))
    transitions.append(Transition.trueDate(k1, .second))
    transitions.append(Transition.trueDate(k2, .new))
    return transitions
  }
  
  /// A tuple array containing the date of each
  /// transition in a cycle:
  ///
  /// The array index of each transition is:
  ///
  /// + `[0] New moon`
  /// + `[1] First quarter`
  /// + `[2] Full moon`
  /// + `[3] Second quarter`
  /// + `[4] Next new moon`
  ///
  typealias Transitions = [TransitionDate]

  /// A tuple containing the date for a transition.
  ///
  typealias TransitionDate = (transition: Transition, date: Date)
}
 
// MARK: - Transition Definition

public extension Moon {
  
  /// The transitions of the moon: **New Moon,
  /// First Quarter, Full Moon,** and **Second Quarter**
  enum Transition {
    /// New moon.
    case new
    /// First quarter.
    case first
    /// Full moon.
    case full
    /// Second quarter.
    case second
  }
}

// MARK: - Transition Custom String Convertable

extension Moon.Transition: CustomStringConvertible {
  
  public var description: String {
    switch self {
    case .new: return "New Moon"
    case .first: return "First Quarter"
    case .full: return "Full Moon"
    case .second: return "Second Quarter"
    }
  }
}

// MARK: - Transition Interface

extension Moon.Transition {
    
  /// The point in the lunar cycle at which
  /// the transition occurs.
  var index: Double {
    switch self {
    case .new: return 0.0
    case .first: return 0.25
    case .full: return 0.5
    case .second: return 0.75
    }
  }
}

// MARK: - Transition Model

fileprivate extension Moon.Transition {
  
  /// The calculated true date of the transition.
  ///
  /// - Parameters:
  ///   - meanPhase: The mean phase of the moon.
  ///   - transition: The transition.
  ///
  static func trueDate(_ meanPhase: Double, _ transition: Self) -> Moon.TransitionDate {
    
    return (transition: transition,
            date: Moon.truePhase(meanPhase,
                           transtition: transition).date)
  }
}

// MIT License:

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
