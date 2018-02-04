//
//  MBTableViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 30/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class MBTableViewController: UITableViewController {
    
    var asks:[NSArray] = [] //[[32560.00001,101.00001], [32562.00001,102.00001], [32533.00001,102.20001]]
    var bids:[NSArray] = [] //[[32664.00001,103.00001], [32668.00001,101.50001], [32633.00001,102.00001]]
    
    var coin: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderbook(coin: self.coin!)

    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! MBTableViewCell

        if bids.count > 0 {
            let bid:NSArray = bids[indexPath.row]
            let quantidadeBid:NSNumber = bid[1] as! NSNumber
            let precoBid:NSNumber = bid[0] as! NSNumber
            
            cell.compraQuantidadeLabel.text = String(describing: quantidadeBid)
            cell.compraPrecoLabel.text = String(describing: precoBid)
            
            let ask:NSArray = asks[indexPath.row]
            let quantidadeAsk:NSNumber = ask[1] as! NSNumber
            let precoAsk:NSNumber = ask[0] as! NSNumber
            
            cell.vendaQuantidadeLabel.text = String(describing: quantidadeAsk)
            cell.vendaPrecoLabel.text = String(describing: precoAsk)
         
        }

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        
        self.orderbook(coin: self.coin!)
        self.tableView.reloadData()
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.orderbook(coin: self.coin!)
            self.tableView.reloadData()
        }
    }
    
    func orderbook(coin: String){
        if let url = URL(string: "https://www.mercadobitcoin.net/api/" + coin + "/orderbook/") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                                self.asks = (objetoJson["asks"] as? [NSArray])!
                                self.bids = (objetoJson["bids"] as? [NSArray])!
                            }
                        }catch {
                            print("Erro ao formatar o retorno.")
                        }
                    }
                }
                else{
                    print("Erro ao fazer a consulta do preço.")
                }
            }
            tarefa.resume()
        }
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
