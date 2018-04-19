import UIKit
import RealmSwift
class EditarViewController: UIViewController {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var edad: UITextField!
    @IBOutlet weak var telefono: UITextField!
    
    var contactos : Contactos!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nombre.text = contactos.nombre
        edad.text = "\(contactos.edad)"
        telefono.text = contactos.telefono
    }

    
    @IBAction func editar(_ sender: UIButton) {
        let id = contactos.id
        let contacto = Contactos()
        guard let nombre = nombre.text else { return }
        guard let edad = edad.text else { return }
        guard let telefono = telefono.text else { return }
        contacto.id = id
        contacto.nombre = nombre
        contacto.edad = Int(edad)!
        contacto.telefono = telefono
        
        do {
            try realm.write {
                realm.add(contacto, update: true)
                self.navigationController?.popViewController(animated: true)
            }
        } catch let error as NSError {
            print("no guardo", error)
        }
        
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
