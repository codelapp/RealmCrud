import Foundation
import RealmSwift

class Contactos: Object {
    
    @objc dynamic var nombre = ""
    @objc dynamic var edad = 0
    @objc dynamic var telefono: String? = nil
    @objc dynamic var id = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
