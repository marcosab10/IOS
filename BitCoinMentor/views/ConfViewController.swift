//
//  ConfViewControllerBN.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 29/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class ConfViewController: UIViewController {
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var timer:Timer?
    var nameAnalyzeExchange:String?
    var typeCoin:String?
    
    @IBOutlet weak var ativarAnaliseSwitch: UISwitch!
    @IBOutlet weak var ativarNotificacoesSwitch: UISwitch!
    @IBOutlet weak var notificacaoPositivaSwitch: UISwitch!
    @IBOutlet weak var notificacaoNegativaSwitch: UISwitch!
    @IBOutlet weak var notificacoesAtivasLabel: UILabel!
    @IBOutlet weak var alertaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.loadAnalyzeExchange(nameAnalyzeExchange!, typeCoin!)
        
        if let analyzeExchangeTO = bitCoinCoreData.getAnalyzeExchangeTO(nameAnalyzeExchange!, typeCoin!) {
            
            ativarAnaliseSwitch.isOn =  Bool(analyzeExchangeTO.activeAnalyzes!)!
            ativarNotificacoesSwitch.isOn =  Bool(analyzeExchangeTO.activeNotification!)!
       
            notificacaoPositivaSwitch.isOn = Bool(analyzeExchangeTO.notifyPositive!)!
            notificacaoNegativaSwitch.isOn = Bool(analyzeExchangeTO.notifyNegative!)!
        }
        
        if nameAnalyzeExchange == "Binance" {
            alertaLabel.text = "Alerta Binance"
        }
        else if nameAnalyzeExchange == "MercadoBitcoin" {
            alertaLabel.text = "Alerta Mercado Bitcoin"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        service.loadAnalyzeExchange(nameAnalyzeExchange!, typeCoin!)
        verificarAnaliseNoficacoesAtivas(nameAnalyzeExchange!, typeCoin!)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            
            self.verificarAnaliseNoficacoesAtivas(self.nameAnalyzeExchange!, self.typeCoin!)
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    @IBAction func salvar(_ sender: Any) {
        if let analyzeExchangeTO = bitCoinCoreData.getAnalyzeExchangeTO(nameAnalyzeExchange!, typeCoin!) {
            
            analyzeExchangeTO.activeAnalyzes = String(ativarAnaliseSwitch.isOn)
            analyzeExchangeTO.activeNotification  = String(ativarNotificacoesSwitch.isOn)
            analyzeExchangeTO.notifyPositive = String(notificacaoPositivaSwitch.isOn)
            analyzeExchangeTO.notifyNegative  = String(notificacaoNegativaSwitch.isOn)
            
            if let tokenValue = UserDefaults.standard.object(forKey: "token") {
                let token = tokenValue as! String
                 analyzeExchangeTO.token = token
            }
            
            service.saveAnalyzeExchange(analyzeExchangeTO: analyzeExchangeTO)
        }
    }
    
    fileprivate func verificarAnaliseNoficacoesAtivas(_ name: String, _ typeCoin: String){
        //Testa se a URL existe
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/verifyLiveAnalyzeNotifies?name=" + name + "&typeCoin=" + typeCoin) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        
                        let retorno = String(data: dadosRetorno, encoding: .utf8)
                        
                        DispatchQueue.main.async {
                            if retorno == "Success"{
                               self.notificacoesAtivasLabel.text = "Análise Ativa!"
                            }
                            else{
                               self.notificacoesAtivasLabel.text = ""
                            }
                        }
                    }
                }
                else{
                    print("Erro ao verificar se a análise está ativa.")
                }
            }
            tarefa.resume()
        }
    }
    
   

}
