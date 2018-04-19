import UIKit
import RealmSwift
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    
    let realm = try! Realm()
    
    var listaContactos : Results<Contactos>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listaContactos = realm.objects(Contactos.self)
        tabla.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaContactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contacto = listaContactos[indexPath.row]
        cell.textLabel?.text = contacto.nombre
        cell.detailTextLabel?.text = "\(contacto.edad)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            if let id = self.tabla.indexPathForSelectedRow {
                let fila = listaContactos[id.row]
                let destino = segue.destination as! EditarViewController
                destino.contactos = fila
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let contacto = self.listaContactos[indexPath.row]
        
        try! self.realm.write {
            realm.delete(contacto)
            self.tabla.reloadData()
        }
        
    }


    @IBAction func save(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "contactos", message: "guarda un contacto", preferredStyle: .alert)
        
        alerta.addTextField { (nombre) in
            nombre.placeholder = "Nombre de contacto"
        }
        alerta.addTextField { (edad) in
            edad.placeholder = "Edad del contacto"
        }
        alerta.addTextField { (telefono) in
            telefono.placeholder = "Telefono del contacto"
        }
        
        let save = UIAlertAction(title: "guardar", style: .default) { (action) in
            
            guard let nombre = alerta.textFields?.first?.text else { return }
            guard let edad = Int((alerta.textFields?[1].text)!) else { return }
            guard let telefono = alerta.textFields?.last?.text else { return}
            
            let contacto = Contactos()
            contacto.nombre = nombre
            contacto.edad = edad
            contacto.telefono = telefono
            contacto.id = UUID().uuidString
            
            try! self.realm.write {
                self.realm.add(contacto)
                self.tabla.reloadData()
                print("guardo")
            }
        }
        let cancel = UIAlertAction(title: "cancelar", style: .destructive, handler: nil)
        
        alerta.addAction(save)
        alerta.addAction(cancel)
        present(alerta, animated: true, completion: nil)
        
        
    }
    

    @IBAction func borrar(_ sender: UIBarButtonItem) {
        try! realm.write {
            realm.deleteAll()
            tabla.reloadData()
        }
    }
}











