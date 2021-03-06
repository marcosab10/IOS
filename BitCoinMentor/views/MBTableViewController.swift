//
//  MBTableViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 30/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class MBTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let service: BitCoinMentorService = BitCoinMentorService()
    let util:Util = Util()
    var timer:Timer?
    var asks:[NSArray] = [] //[[32560.00001,101.00001], [32562.00001,102.00001], [32533.00001,102.20001]]
    var bids:[NSArray] = []
    var trades:NSArray = []
    var coin: String?
    let ticket:TicketTO = TicketTO()
    let idExchange:String = "1"
    
    var modoRapido:String = "false"
    var modoDesc:String = "Lento"
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var tituloLabel: UILabel!
    
    
    @IBAction func definirModo(_ sender: Any) {
        if modoDesc == "Lento" {
            modoDesc = "Rapido"
            modoRapido = "true"
        }
        else {
            modoDesc = "Lento"
            modoRapido = "false"
        }
        definirTitulo()
    }
    
    
    @IBAction func comprar(_ sender: Any) {
        let alerta = UIAlertController(title: "Comprar", message: "Deseja comprar?", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        let confirmar = UIAlertAction(title: "Confirmar", style: .default) { (acao) in
            
            self.ticket.coin = self.coin
            self.ticket.idExchange = self.idExchange
            self.ticket.modoRapido = self.modoRapido

            self.service.buyPriceAuto(ticketTO: self.ticket)
        }
        
        alerta.addAction(confirmar)
        alerta.addAction(cancelar)
        
        present(alerta, animated: true, completion: nil)

        print("Comprar " + coin! + " " + modoDesc)
    }
    
    @IBAction func Vender(_ sender: Any) {
        let alerta = UIAlertController(title: "Vender", message: "Deseja vender?", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        let confirmar = UIAlertAction(title: "Confirmar", style: .default) { (acao) in
            
            self.ticket.coin = self.coin
            self.ticket.idExchange = self.idExchange
            self.ticket.modoRapido = self.modoRapido
            
            self.service.sellPriceAuto(ticketTO: self.ticket)
        }
        
        alerta.addAction(confirmar)
        alerta.addAction(cancelar)
        
        present(alerta, animated: true, completion: nil)
        
        print("Vender " + coin! + " " + modoDesc)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderbook(coin: self.coin!)
        self.trades(coin: self.coin!)
        
        definirTitulo()
        
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        
        self.orderbook(coin: self.coin!)
        self.trades(coin: self.coin!)
        self.tableview.reloadData()
        
       self.timer = Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.orderbook(coin: self.coin!)
            self.trades(coin: self.coin!)
            self.tableview.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! MBHeaderTableViewCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! MBFooterTableViewCell
        
        return cell
    }
    
    //Metodo executado quando se seleciona uma linha
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0;
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            

            if trades.count > 0 {
                let posicao = indexPath.row + 1
                
                if let trade = trades[trades.count - posicao] as? [String: Any] {
                    let quantidadeTrade:NSNumber = trade["amount"] as! NSNumber
                    let precoTrade:NSNumber = trade["price"] as! NSNumber
                    let tipo:String = trade["type"] as! String
                    let data:NSNumber  = trade["date"] as! NSNumber
                    
                    cell.negociadoPrecoLabel.text = String(describing: precoTrade)
                    cell.negociadoQuantidadeLabel.text = String(describing: quantidadeTrade)
                    
                    if tipo == "sell" {
                        cell.negociadoQuantidadeLabel.textColor = UIColor.red
                    }
                    else if tipo == "buy" {
                        cell.negociadoQuantidadeLabel.textColor = UIColor.green
                    }
                    
                    cell.horaLabel.text = util.formatarData(dataMilisegundos: data)
                }
            }
            
            
        }
        return cell
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
    
    func trades(coin: String){
        if let url = URL(string: "https://www.mercadobitcoin.net/api/" + coin + "/trades/") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? NSArray {
                                self.trades = objetoJson
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
    
    fileprivate func definirTitulo() {
        if coin == "BTC" {
            tituloLabel.text = "Bitcoin " + modoDesc
        } else if coin == "LTC" {
            tituloLabel.text = "LiteCoin "  + modoDesc
        } else if coin == "BCH" {
            tituloLabel.text = "BitcoinCash "  + modoDesc
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
