//
//  ViewControllerEquipo.swift
//  EvidenciaFinal
//
//  Created by Alumno on 16/11/22.
//

import UIKit
import CoreData
class ViewControllerEquipo: UIViewController {

    @IBOutlet weak var tablaJugadores: UITableView!
    
    var listaJugadores = [Jugador]()
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tablaJugadores.delegate = self
        tablaJugadores.dataSource = self
        leerTareas()
    }

    
    
    @IBAction func nuevoJugador(_ sender: UIBarButtonItem) {
        var nombreTarea = UITextField()
        
        let alerta = UIAlertController(title: "Nueva", message: "Tarea", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let nuevaTarea = Jugador(context: self.contexto)
            nuevaTarea.nombre = nombreTarea.text
            //nuevaTarea.realizada = false
            
            self.listaJugadores.append(nuevaTarea)
            
            self.guardar()
        }
        
        alerta.addTextField { textFieldAlert in
            textFieldAlert.placeholder = "Escribe tu texto aqui.."
            nombreTarea =  textFieldAlert
        }
        alerta.addAction(accionAceptar)
        
        present(alerta,animated: true)
    }
    
    //Guarda/actualiza la tabla
    func guardar(){
        do {
            try contexto.save()
        }catch{
            print(error.localizedDescription)
        }
        self.tablaJugadores.reloadData()
    }
    
    //lee las tareas
    func leerTareas(){
        let solicitud : NSFetchRequest<Jugador> = Jugador.fetchRequest()
        
        do {
            listaJugadores = try contexto.fetch(solicitud)
        } catch{
            print(error.localizedDescription)
        }
    }
    extension ViewControllerEquipo: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listaJugadores.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tablaJugadores.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
            
            let  tarea = listaJugadores[indexPath.row]
            //Operadores ternearios
            //pone los valores de la tarea en la tabla
            
            celda.textLabel?.text = tarea.nombre
            //pone de color la tarea depende si esa hecha o no
           // celda.textLabel?.textColor = tarea.realizada ? .black : .blue
            
            //celda.detailTextLabel?.text = tarea.realizada ? "Completada" : "Por completar"
            
            //marcar tareas completadas
           // celda.accessoryType = tarea.realizada ? .checkmark : .none
            
            return celda
        }
        
        //Tabla para poner una paloma a la tarea realizada
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //Palomar la tarea
            if tablaJugadores.cellForRow(at: indexPath)?.accessoryType == .checkmark{
                tablaJugadores.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                tablaJugadores.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            //Editar en coredata
            //listaJugadores[indexPath.row].realizada = !listaJugadores[indexPath.row].realizada
            
            guardar()
            
            //deselecciona la tarea
            tablaJugadores.deselectRow(at: indexPath, animated: true)
        }
        
        //Tabla para eliminar las tareas
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar") { _,_,_  in
                self.contexto.delete(self.listaJugadores[indexPath.row])
                self.listaJugadores.remove(at: indexPath.row)
                self.guardar()
            }
            accionEliminar.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [accionEliminar])
        }
        
         
    }
    
    
}

