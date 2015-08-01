import UIKit

class MainViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    println("ssdfd")

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func say(sender: UIButton) {
    REST.resource(.POST, Event.self, path: nil, params: nil) { (let event, let response, let error) in
      if let error = error {
      } else {
      }
    }
  }
}

