//
//  AlarmEditViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 21/10/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class AlarmEditViewController: UIViewController {
    
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var alarmTO: AlarmTO?
    var idExchange:NSNumber?

    
    @IBOutlet weak var moedaText: UITextField!
    @IBOutlet weak var precoText: UITextField!
    @IBOutlet weak var intervaloText: UITextField!
    @IBOutlet weak var numeroNotificacoesText: UITextField!
    @IBOutlet weak var notificacaoAtivaSwitch: UISwitch!
    @IBOutlet weak var repetirSwitch: UISwitch!
    @IBOutlet weak var orientacaoPositiva: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Arrumar para pegar do usuário
        idExchange = 2

        carregarValores()
    }
    

    @IBAction func salvar(_ sender: Any) {
        if alarmTO == nil
        {
            alarmTO = AlarmTO()
        }
        
        if let tokenValue = UserDefaults.standard.object(forKey: "token") {
            let token = tokenValue as! String
            alarmTO?.token = token
        }
        alarmTO?.idExchange = idExchange
        alarmTO?.coin = moedaText.text
        alarmTO?.price = precoText.text
        if let intervalo = Int(intervaloText.text!) {
            alarmTO?.notificationInterval = NSNumber(value:intervalo)
        }
        if let numeroNotificacoes = Int(numeroNotificacoesText.text!) {
            alarmTO?.notificationNumber = NSNumber(value:numeroNotificacoes)
        }
        alarmTO?.activeNotification = String(notificacaoAtivaSwitch.isOn)
        alarmTO?.repeatAlarm = String(repetirSwitch.isOn)
        
        if(orientacaoPositiva.isOn){
            alarmTO?.orientation = "positive"
        }
        else{
            alarmTO?.orientation = "negative"
        }
        
        service.saveAlarm(alarmTO: alarmTO!)
    }
    
    fileprivate func carregarValores() {
        if alarmTO != nil
        {
            moedaText.text = alarmTO?.coin
            precoText.text = alarmTO?.price
            let notificationIntervalTemp:NSNumber = (alarmTO?.notificationInterval)!
            intervaloText.text = String(describing: notificationIntervalTemp)
            let notificationNumberTemp:NSNumber = (alarmTO?.notificationNumber)!
            numeroNotificacoesText.text = String(describing: notificationNumberTemp)
            notificacaoAtivaSwitch.isOn = Bool((alarmTO?.activeNotification!)!)!
            repetirSwitch.isOn = Bool((alarmTO?.repeatAlarm!)!)!
            
            if(alarmTO?.orientation == "positive"){
                orientacaoPositiva.isOn = true
            }
            else{
                orientacaoPositiva.isOn = false
            }
            
        }
    }
    
    //Esconder teclado ao clicar fora
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
