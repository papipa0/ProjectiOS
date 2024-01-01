

import Foundation

struct Place: Codable, Identifiable, Hashable {
    
    var id: Int?
    var _id: String
    var imagelocation: String
    var namelocation: String
    var owner: String
    var emailShare: String?
    var shared_with_id: String?
}
