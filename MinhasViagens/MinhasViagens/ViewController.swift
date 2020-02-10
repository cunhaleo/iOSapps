//
//  ViewController.swift
//  MinhasViagens
//
//  Created by Leonardo Cunha on 07/02/20.
//  Copyright © 2020 Leonardo Cunha. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //Referenciando mapa
    @IBOutlet weak var mapa: MKMapView!
    //Instanciando um gerenciador de localizacao
    var gerenciaLocalizacao = CLLocationManager()
    var viagem: Dictionary<String, String> = [:]
    var indiceSelecionado: Int!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let reconheceGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:)))
        mapa.addGestureRecognizer(reconheceGesto)
        reconheceGesto.minimumPressDuration = 2
        let indice = indiceSelecionado
        configuraGerenciadorLocalizacao()
        if indice == -1 {
            // Exibir posicao atual do usuario

            }
            else{
                exibirAnotacao(viagem: viagem)
            }
    
    }
    // Funcao que centraliza o mapa para minha posicao atual
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localAtualizado = locations.last!
        exibirNoMapa(latitude: localAtualizado.coordinate.latitude, longitude: localAtualizado.coordinate.longitude)
    }

    func exibirNoMapa(latitude: Double, longitude: Double) {
        
        let deltaLong: CLLocationDegrees = 0.01
        let deltaLat: CLLocationDegrees = 0.01
        let localSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: latitude, longitude: longitude)
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: localSpan)
        self.mapa.setRegion(regiao, animated: true)
     
    }
    
    
    func exibirAnotacao(viagem: Dictionary<String, String> ) {
        // Valida o dicionario viagem e transforma para double
        if let localViagem = viagem ["Local"] {
            if let latitude = viagem ["Latitude"] {
                if let longitude = viagem ["Longitude"] {
                    if let longitudeS = Double (longitude) {
                        if let latitudeS = Double(latitude) {
                            let anotacao = MKPointAnnotation()
                            anotacao.coordinate.latitude = latitudeS
                            anotacao.coordinate.longitude = longitudeS
                            anotacao.title = localViagem
                            self.mapa.addAnnotation(anotacao)
                            
                            // Exibe no mapa
                            exibirNoMapa(latitude: latitudeS, longitude: longitudeS)
                        }
                    }
                }
            }
        }
    }
    //Funcao para marcar no mapa quando pressionado por 2s
    @objc func marcar(gesture: UIGestureRecognizer) {
       var localCompleto = "Endereço não encontrado."
        //Tratativa para nao realizar 2 vezes a acao (Began e Ended)
        if gesture.state == UIGestureRecognizer.State.began {
            
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            CLGeocoder().reverseGeocodeLocation( localizacao) { (local, erro) in
                if erro == nil {
                    if let dadoslLocal = local?.first {
                        if let localNome = dadoslLocal.name {
                            localCompleto = localNome
                        }
                        if let localEndereco = dadoslLocal.thoroughfare {
                            localCompleto = localEndereco
                        }
                    }
                } else {
                    print(erro as Any)
                }
                //viagem recebe a nova localizacao que sera salva
                self.viagem = [ "Local":localCompleto, "Latitude":String(coordenadas.latitude), "Longitude":String(coordenadas.longitude) ]
                
                //instanciando classe de armazenamento de dados
                ArmazenamentoDeDados().salvarViagem(viagem: self.viagem )
                
                //Exibe anotacao (pino)
                let anotacao = MKPointAnnotation()
                anotacao.coordinate.latitude = coordenadas.latitude
                anotacao.coordinate.longitude = coordenadas.longitude
                anotacao.title = localCompleto
                self.mapa.addAnnotation(anotacao)
            }
        }
        
    }


    func configuraGerenciadorLocalizacao() {
            gerenciaLocalizacao.delegate = self
            gerenciaLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
            gerenciaLocalizacao.requestWhenInUseAuthorization()
        if indiceSelecionado == -1 {
            gerenciaLocalizacao.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied{
            // Alarme de permissao caso o usuario nao tenha habilitado localizacao
            let alertaController = UIAlertController(title: "Permissão de localização", message: "Altere sua configuração de privacidade para utilizar o app.", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default) { (configuraAlerta) in
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            }
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaController.addAction(acaoCancelar)
            alertaController.addAction(acaoConfiguracoes)
            
            present(alertaController, animated: true, completion: nil)
        }   
    }
}

