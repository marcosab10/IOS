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
                        celula.textLabel?.text =  coin
                        celula.detailTextLabel?.text = price + "           " + orientation
                        
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
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
