//
//  LocaisViagensViewControllerTableViewController.swift
//  MinhasViagens
//
//  Created by Leonardo Cunha on 07/02/20.
//  Copyright © 2020 Leonardo Cunha. All rights reserved.
//

import UIKit

class LocaisViagensViewControllerTableViewController: UITableViewController {

    var locaisViagens: [Dictionary<String, String>] = []
    var controleAcao = "adicionar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }

    override func viewDidAppear(_ animated: Bool) {
        locaisViagens = ArmazenamentoDeDados().listarViagens()
        tableView.reloadData()
        controleAcao = "adicionar"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return locaisViagens.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)

        let viagem = locaisViagens[indexPath.row]["Local"]
        
        cell.textLabel?.text = viagem

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            ArmazenamentoDeDados().removerViagem(indice: indexPath.row)
            locaisViagens = ArmazenamentoDeDados().listarViagens()
            tableView.reloadData()
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controleAcao = "listar"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verLocal" {
            let viewControllerDestino = segue.destination as! ViewController
            print(controleAcao)
            if self.controleAcao == "listar" {
                
                if let indiceRecuperado = sender {
                    
                    let indice = indiceRecuperado as! Int
                    
                    viewControllerDestino.viagem = locaisViagens[ indice ]
                    viewControllerDestino.indiceSelecionado = indice
                }
                
            }else{
                viewControllerDestino.indiceSelecionado = -1
                viewControllerDestino.viagem = [:]
            }
        }
        
        

    }           
}

    
    
