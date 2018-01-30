//
//  ConfViewControllerMB.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 29/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class ConfViewControllerMB: UIViewController {
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    let nameAnalyzeExchange:String = "MercadoBitcoin"
    
    @IBOutlet weak var ativarAnaliseSwitch: UISwitch!
    @IBOutlet weak var ativarNotificacoesSwitch: UISwitch!
    @IBOutlet weak var notificacoesAtivasLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.loadAnalyzeExchange(nameAnalyzeExchange)
        
        if let analyzeExchangeTO = bitCoinCoreData.getAnalyzeExchangeTO(nameAnalyzeExchange) {
            
            ativarAnaliseSwitch.isOn =  Bool(analyzeExchangeTO.activeAnalyzes!)!
            ativarNotificacoesSwitch.isOn =  Bool(analyzeExchangeTO.activeNotification!)!
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        verificarAnaliseNoficacoesAtivas(nameAnalyzeExchange)
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            
            self.verificarAnaliseNoficacoesAtivas(self.nameAnalyzeExchange)
            
        }
    }

    @IBAction func salvar(_ sender: Any) {
        if let analyzeExchangeTO = bitCoinCoreData.getAnalyzeExchangeTO(nameAnalyzeExchange) {
            
            analyzeExchangeTO.activeAnalyzes = String(ativarAnaliseSwitch.isOn)
            analyzeExchangeTO.activeNotification  = String(ativarNotificacoesSwitch.isOn)
            
            if let tokenValue = UserDefaults.standard.object(forKey: "token") {
                let token = tokenValue as! String
                analyzeExchangeTO.token = token
            }
            
            service.saveAnalyzeExchange(analyzeExchangeTO: analyzeExchangeTO)
        }
        
    }
    
    fileprivate func verificarAnaliseNoficacoesAtivas(_ name: String){
        //Testa se a URL existe
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/verifyLiveAnalyzeNotifies?name=" + name) {
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
