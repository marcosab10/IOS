//
//  AlarmControlVC.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 29/12/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class AlarmControlVC: UIViewController {

    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var timer:Timer?
    let idAlarmControl:NSNumber = 1
    

    @IBOutlet weak var notificarAlarmesSwitch: UISwitch!
    @IBOutlet weak var verificacaoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.loadAlarmControl()
        
        if let alarmControlTO = bitCoinCoreData.getAlarmControlTO(self.idAlarmControl) {
            
            notificarAlarmesSwitch.isOn =  Bool(alarmControlTO.notifyAlarm!)!
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        service.loadAlarmControl()
        verifyLiveAlarmControl(self.idAlarmControl.stringValue)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            
            self.verifyLiveAlarmControl(self.idAlarmControl.stringValue)
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    @IBAction func salvar(_ sender: Any) {
        if let alarmControlTO = bitCoinCoreData.getAlarmControlTO(self.idAlarmControl) {
            
            alarmControlTO.notifyAlarm = String(notificarAlarmesSwitch.isOn)
            
            service.startStopMotorAlarms(alarmControlTO: alarmControlTO)
        }
    }
    
    fileprivate func verifyLiveAlarmControl(_ id: String){
        //Testa se a URL existe
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/verifyLiveAlarmControl?idAlarm=" + id) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        
                        let retorno = String(data: dadosRetorno, encoding: .utf8)
                        
                        DispatchQueue.main.async {
                            if retorno == "Success"{
                                self.verificacaoLabel.text = "Verificação Ativa!"
                            }
                            else{
                                self.verificacaoLabel.text = ""
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
