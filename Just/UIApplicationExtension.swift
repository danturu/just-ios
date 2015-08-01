import UIKit

private let networkActivityQueue = dispatch_queue_create("\(NSBundle.mainBundle().bundleIdentifier!).NetworkActivityQueue", nil)
private var networkActivityCount = 0

extension UIApplication {
  func showNetworkActivityIndicator() {
    dispatch_sync(networkActivityQueue) {
      if (networkActivityCount == 0) {
        self.networkActivityIndicatorVisible = true
      }
      
      networkActivityCount++
    }
  }
  
  func hideNetworkActivityIndicator() {
    dispatch_sync(networkActivityQueue) {
      networkActivityCount--
      
      if (networkActivityCount == 0) {
        self.networkActivityIndicatorVisible = false
      }
    }
  }
}
