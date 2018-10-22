//
//  AlarmViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 27/08/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class AlarmViewController: UITableViewController {
    
    var alarmsTO: [AlarmTO] = []
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var timer:Timer?
    var idExchange:NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Arrumar para pegar do usuário 
        idExchange = 2
        carregarAlarmes(true)
        
    }
    
    fileprivate func carregarAlarmes(_ comIntervalo:Bool) {
        self.service.loadAlarms(idExchange!)
        if comIntervalo {
            sleep(1)
        }
        self.alarmsTO = self.bitCoinCoreData.getAlarmsTO(idExchange!)!
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 2.0
        
        carregarAlarmes(false)
        self.tableView.reloadData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.carregarAlarmes(true)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsTO.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let alarmTO = self.alarmsTO[indexPath.row]
        
        if let coin = alarmTO.coin {
            if let price = alarmTO.price {
                if let orientation   = alarmTO.orientation {
                    if let activeNotification = alarmTO.activeNotification {
                        var orientationText:String = ""
                        
                        if(orientation == "positive"){
                            orientationText = "positive"
                        }
                        else {
                            orientationText = "negative"
                        }
                        
                        celula.textLabel?.text =  coin
                        celula.detailTextLabel?.text = price + "           " + orientationText
                        
                        let activeNotification = NSString(string:activeNotification).boolValue
                        
                        if(activeNotification){
                            celula.detailTextLabel?.textColor = UIColor.green
                        }
                        else{
                            celula.detailTextLabel?.textColor = UIColor.red
                        }
                    }
                }
            }
        }
        
        return celula
    }
    
    //Metodo executado quando se seleciona uma linha
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let alarmTO = alarmsTO[indice]
        self.performSegue(withIdentifier: "editarAlarme", sender: alarmTO)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editarAlarme" {
            let viewDestino = segue.destination as! AlarmEditViewController
            
            viewDestino.alarmTO = sender as? AlarmTO
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            let indice = indexPath.row
            let alarmTO = self.alarmsTO[indice]
            service.deleteAlarm(String(describing: alarmTO.id!))
            bitCoinCoreData.deleteAlarm(alarmTO.id!)
            
            self.alarmsTO.remove(at: indice) // remove do array
            self.tableView.deleteRows(at: [indexPath], with: .automatic) // remover da tabela
        }
    }


}
