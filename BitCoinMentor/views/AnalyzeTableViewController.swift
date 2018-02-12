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
    var analyzes: [NSManagedObject] = []
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var nameAnalyzeExchange:String?
    var analyzeExchangeTO:AnalyzeExchangeTO?
    
    let binance = "Binance"
    let mercadoBitcoin = "MercadoBitcoin"
    
    @IBOutlet weak var ultimoPrecoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.loadAnalyzeExchange(nameAnalyzeExchange!)
        service.loadAnalyzes(nameAnalyzeExchange!)
        carregarAnalises()
        
        if nameAnalyzeExchange == binance {
            self.title = "Binance"
        }
        else if nameAnalyzeExchange == mercadoBitcoin {
            self.title = "Mercado Bitcoin"
        }
    }
    
    fileprivate func carregarAnalises() {
        if let analyzeExchangeTOBD = self.bitCoinCoreData.getAnalyzeExchangeTO(self.nameAnalyzeExchange!) {
            self.analyzeExchangeTO = analyzeExchangeTOBD
            
            if self.analyzeExchangeTO != nil {
                self.analyzes = self.bitCoinCoreData.listarAnalyzes((self.analyzeExchangeTO?.id!)!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let confViewController = segue.destination as? ConfViewController {

            confViewController.nameAnalyzeExchange =  self.nameAnalyzeExchange
        
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return analyzes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let analyze = self.analyzes[indexPath.row]
        if let timeMinutes = analyze.value(forKey: "timeMinutes") {
            if let percentage = analyze.value(forKey: "percentage"){
                if let firstPrice = analyze.value(forKey: "firstPrice"){
                    if let lastPrice = analyze.value(forKey: "lastPrice"){
                        
                        let timeMinutesText = String(describing: timeMinutes)
                        let percentageText = percentage as! String
                        let firstPriceText = firstPrice as! String
                        let lastPriceText = lastPrice as! String
                        
                        if nameAnalyzeExchange == binance {
                            ultimoPrecoLabel.text = "USD: " + lastPriceText
                        }
                        else if nameAnalyzeExchange == mercadoBitcoin {
                            ultimoPrecoLabel.text = "R$: " + lastPriceText
                        }
                        
                        celula.textLabel?.text =  timeMinutesText + " Minutos"
                        celula.detailTextLabel?.text = firstPriceText + "           " + percentageText + " %  "
                        
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
 
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0

        service.loadAnalyzes(nameAnalyzeExchange!)
        
        carregarAnalises()
        self.tableView.reloadData()
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.service.loadAnalyzes(self.nameAnalyzeExchange!)
            self.carregarAnalises()
            self.tableView.reloadData()
        }
    }
    
    //Metodo executado quando se seleciona uma linha
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        //let indice = indexPath.row
        //let anotacao = anotacoes[indice]
        //self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
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
