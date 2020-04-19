//  DC Fitness App
//
//  Version 1.0
//
//  Created by Kevin Cattran Sr
//

import Foundation

enum SessionState {
  case notStarted
  case active
  case finished
}

class Session {
  
  var state : SessionState = .notStarted
  
  func start() {
    state = .active
  }
  
  func end() {
    state = .finished
  }
  
  func clear() {
    state = .notStarted
  }
}

