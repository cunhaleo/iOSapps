//
//  ViewController.swift
//  TrabalhandoComMapas
//
//  Created by Leonardo Cunha on 04/02/20.
//  Copyright © 2020 Leonardo Cunha. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var velocidadeLabel: UILabel!
    
    
    // Referencias de Label
    @IBOutlet weak var textoLongitude: UILabel!
    @IBOutlet weak var textoLatitude: UILabel!
    
    // Referenciando o mapa
    @IBOutlet weak var mapa: MKMapView!
    
    // Instanciando um objeto do tipo LocationManeger
    var localizaGerencia = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configurando o gerenciador de localizacao
        localizaGerencia.delegate = self
        localizaGerencia.desiredAccuracy = kCLLocationAccuracyBest
        localizaGerencia.requestWhenInUseAuthorization()
        localizaGerencia.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Tratamento caso o usuario nao tenha habilitado o uso da localizacao
        // TO DO : Nao está sendo alertado a cada didViewLoad (?)
        if status == .denied {
            
            //criando o alert controller
            let alertaController = UIAlertController (title: "Permissão de localização", message: "Necessário acesso a sua localização", preferredStyle: .alert)
            
            // criando as acoes do alerta
            let acaoConfig = UIAlertAction (title: "Abrir configurações", style: .default) { (alertaConfig) in
                if let configuracoes = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(configuracoes as URL)
                }
            }
            let acaoCancelar = UIAlertAction (title: "Cancelar", style: .default, handler: nil)
            
            // adicionando as acoes criadas ao alert controller
            alertaController.addAction(acaoConfig)
            alertaController.addAction(acaoCancelar)
            
            // exibindo o alert controller
            present(alertaController,animated:  true, completion: nil)
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // recupera localizacao atual do usuario
        let localizacaoUsuario: CLLocation = locations.last!
        
        // localizacao a ser mostrada
        let latitude: CLLocationDegrees = localizacaoUsuario.coordinate.latitude
        let longitude: CLLocationDegrees = localizacaoUsuario.coordinate.longitude
        
        // Area de visualizacao (zoom) inicial
        let deltaLatitude: CLLocationDegrees = 0.01
        let deltaLongitude: CLLocationDegrees = 0.01
        
        // Parametros para utilizar a setRegion
        let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion.init(center: localizacao, span: areaVisualizacao)
        
        //mostra localizacao atualizada no mapa
        mapa.setRegion(region, animated: true)
        
        //Text label latitude, longitude e velocidade
        textoLatitude.text = String (latitude)
        textoLongitude.text = String (longitude)
        velocidadeLabel.text = String(localizacaoUsuario.speed)
    }

}

