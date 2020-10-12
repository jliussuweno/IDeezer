import Foundation
class User {
    var id: Int = 1
    var email: String = "B"
    var password: String = "10"
    
    init() {
    }

    init(id: Int, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
