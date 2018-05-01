//
//  AnalyzeTableViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class AnalyzeTableViewController: UITableViewController {
    var util = Util()
    var analyzesTO: [AnalyzeTO] = []
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var timer:Timer?
    var nameAnalyzeExchange:String?
    var typeCoin:String?
    var analyzeExchangeTO:AnalyzeExchangeTO?
    
    let binance = "Binance"
    let mercadoBitcoin = "MercadoBitcoin"
    
    @IBOutlet weak var ultimoPrecoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.loadAnalyzeExchange(nameAnalyzeExchange!, typeCoin!)
       
        carregarAnalises(false)
        
        if nameAnalyzeExchange == binance {
            self.title = "Binance"
        }
        else if nameAnalyzeExchange == mercadoBitcoin {
            self.title = "Mercado Bitcoin"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 2.0
        
        carregarAnalises(false)
        self.tableView.reloadData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.carregarAnalises(true)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    fileprivate func carregarAnalises(_ comIntervalo:Bool) {
        if let analyzeExchangeTOBD = self.bitCoinCoreData.getAnalyzeExchangeTO(self.nameAnalyzeExchange!, self.typeCoin!) {
            self.analyzeExchangeTO = analyzeExchangeTOBD
            
            if self.analyzeExchangeTO != nil {
                self.service.loadAnalyzes((self.analyzeExchangeTO?.id)!)
                if comIntervalo {
                     sleep(1)
                }
                self.analyzesTO = self.bitCoinCoreData.getAnalyzesTO((self.analyzeExchangeTO?.id)!)!
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let confViewController = segue.destination as? ConfViewController {

            confViewController.nameAnalyzeExchange =  self.nameAnalyzeExchange
            confViewController.typeCoin = self.typeCoin
        }
        
        if segue.identifier == "editarAnalise" {
            let viewDestino = segue.destination as! AnalyzeViewController
            
            viewDestino.analyzeTO = sender as? AnalyzeTO
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            let indice = indexPath.row
            let analyzeTO = self.analyzesTO[indice]
            service.deleteAnalyze(String(describing: analyzeTO.id!))
            bitCoinCoreData.deleteAnalyze(analyzeTO.id!)
            
            self.analyzesTO.remove(at: indice) // remove do array
            self.tableView.deleteRows(at: [indexPath], with: .automatic) // remover da tabela
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return analyzesTO.count
    }
    
    //Metodo executado quando se seleciona uma linha
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let analyzeTO = analyzesTO[indice]
        self.performSegue(withIdentifier: "editarAnalise", sender: analyzeTO)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let analyzeTO = self.analyzesTO[indexPath.row]
    
        if let timeMinutes = analyzeTO.timeMinutes {
            if let percentage = analyzeTO.percentage {
                if let firstPrice = analyzeTO.firstPrice {
                    if let lastPrice = analyzeTO.lastPrice {
                        
                        let timeMinutesText = String(describing: timeMinutes)
                        let percentageText = percentage
                        
                        if nameAnalyzeExchange == binance {
                            ultimoPrecoLabel.text = "USD: " + lastPrice
                        }
                        else if nameAnalyzeExchange == mercadoBitcoin {
                            ultimoPrecoLabel.text = "R$: " + lastPrice
                        }
                        
                        celula.textLabel?.text =  timeMinutesText + " Minutos"
                        celula.detailTextLabel?.text = firstPrice + "           " + percentageText + " %  "
                        
                        let percentageNumber = Double(percentageText)
                        
                        if(percentageNumber! < 0.0){
                            celula.detailTextLabel?.textColor = UIColor.red
                        }
                        else{
                            celula.detailTextLabel?.textColor = UIColor.green
                        }
                        
                    }
                }
            }
        }
        
        return celula
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
