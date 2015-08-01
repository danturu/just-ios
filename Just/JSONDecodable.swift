protocol JSONDecodable {
  static func decode(data: JSONObject?) -> Self?
  static func decode(data: JSONArray) -> [Self]
}