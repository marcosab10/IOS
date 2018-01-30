//
//  ConfViewControllerBN.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 29/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class ConfViewControllerBN: UIViewController {
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    
    @IBOutlet weak var ativarAnaliseSwitch: UISwitch!
    @IBOutlet weak var ativarNotificacoesSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        service.loadAnalyzeExchange("Binance")
        
        if let analyzeExchangeTO = bitCoinCoreData.getAnalyzeExchangeTO("Binance") {
            
            ativarAnaliseSwitch.isOn =  Bool(analyzeExchangeTO.activeAnalyzes!)!
            ativarNotificacoesSwitch.isOn =  Bool(analyzeExchangeTO.activeNotification!)!
            
        }
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        if let analyzeExchangeTO = bitCoinCoreData.getAnalyzeExchangeTO("Binance") {
            
            analyzeExchangeTO.activeAnalyzes = String(ativarAnaliseSwitch.isOn)
            analyzeExchangeTO.activeNotification  = String(ativarNotificacoesSwitch.isOn)
            
            if let tokenValue = UserDefaults.standard.object(forKey: "token") {
                let token = tokenValue as! String
                 analyzeExchangeTO.token = token
            }
            
            service.saveAnalyzeExchange(analyzeExchangeTO: analyzeExchangeTO)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
