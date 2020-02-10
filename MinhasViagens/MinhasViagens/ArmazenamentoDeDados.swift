//
//  ArmazenamentoDeDados.swift
//  MinhasViagens
//
//  Created by Leonardo Cunha on 08/02/20.
//  Copyright © 2020 Leonardo Cunha. All rights reserved.
//

import UIKit

class ArmazenamentoDeDados {
    
    let chaveArmazenamento = "chaveArmazenamento"
    var arrayDicionarios: [ Dictionary<String, String> ] = []
    
    func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func salvarViagem( viagem: Dictionary<String, String> ) {
        
        arrayDicionarios = listarViagens()
        arrayDicionarios.append(viagem)

        getDefaults().set(arrayDicionarios, forKey: chaveArmazenamento)
        getDefaults().synchronize()
    }
    
    func listarViagens() -> [Dictionary<String, String>] {
        let dados = getDefaults().object(forKey: chaveArmazenamento)
        if dados != nil {
            return dados as! Array
        }else {
            return []
        }
    }
    func removerViagem(indice: Int) {
        
        arrayDicionarios = listarViagens()
        arrayDicionarios.remove(at: indice)
        getDefaults().set(arrayDicionarios, forKey: chaveArmazenamento)
        getDefaults().synchronize()
    
    }
}

