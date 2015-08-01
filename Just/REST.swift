import Alamofire

class REST {
  enum Router: URLRequestConvertible {
    case Resource(method: Alamofire.Method, path: [String?], params: [String : AnyObject]?)
    
    var URLRequest: NSURLRequest {
      var url: String {
        switch self {
          case .Resource(let attributes):
            return composeUrl(attributes.path)
        }
      }
      
      var method: String {
        switch self {
          case .Resource(let attributes):
            return attributes.method.rawValue
        }
      }
      
      let request = NSMutableURLRequest(URL: NSURL(string: url)!)
          request.HTTPMethod      = method
          request.timeoutInterval = 30
          request.setValue("application/json", forHTTPHeaderField: "Accept")
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      switch self {
        case .Resource(let attributes):
          if attributes.method == .GET {
            return Alamofire.ParameterEncoding.URL.encode(request, parameters: attributes.params).0
          } else {
            return Alamofire.ParameterEncoding.JSON.encode(request, parameters: attributes.params).0
          }
      }
    }
    
    private func composeUrl(path: [String?]) -> String! {
      return path.reduce(JUST_URL) { (var url, path) in
        if path != nil {
          return url + "/" + path!
        } else {
          return url
        }
      }
    }
  }
  
  class func resource<T where T: JSONSyncable, T: JSONDecodable>(method: Alamofire.Method, _ type: T.Type, path: String?, params: [String : AnyObject]?, completion: (T?, NSHTTPURLResponse?, NSError?) -> Void) {
    UIApplication.sharedApplication().showNetworkActivityIndicator()

    Alamofire.request(Router.Resource(method: method, path: [T.resource(), path], params: params)).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { (request, response, data, error) in
      UIApplication.sharedApplication().hideNetworkActivityIndicator()

      if (error == nil) {
        completion(T.decode(data as? JSONObject), response, nil)
      } else {
        completion(nil, response, error)
      }
    }
  }
  
  class func resources<T where T: JSONSyncable, T: JSONDecodable>(method: Alamofire.Method, _ type: T.Type, path: String?, params: [String : AnyObject]?, completion: ([T], NSHTTPURLResponse?, NSError?) -> Void) {
    UIApplication.sharedApplication().showNetworkActivityIndicator()
    
    Alamofire.request(Router.Resource(method: method, path: [T.resource(), path], params: params)).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { (request, response, data, error) in
      UIApplication.sharedApplication().hideNetworkActivityIndicator()

      if (error == nil) {
        completion(T.decode(data as! JSONArray), response, nil)
      } else {
        completion([], response, error)
      }
    }
  }
}