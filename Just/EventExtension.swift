import Foundation

extension Event: JSONDecodable {
  static func decode(data: JSONObject?) -> Event? {
    if data == nil { return nil }
    
    let id        = data!["id"]         as! String
    let createdAt = data!["created_at"] as! String
    
    return Event(id: id, createdAt: createdAt)
  }
  
  static func decode(data: JSONArray) -> Events {
    return data.map { Event.decode($0 as? JSONObject) as Event! }
  }
}

extension Event: JSONSyncable {
  static func resource() -> String {
    return "events"
  }
}