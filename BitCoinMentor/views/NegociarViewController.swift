//
//  NegociarViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 07/02/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class NegociarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    let ticket:TicketTO = TicketTO()
    var ordensTO: [OrdemTO] = []
    let idExchange:String = "1"
    let statusOrdens:String = "2" //aberta
    
    @IBOutlet weak var reaisLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var bitcoinCashLabel: UILabel!
    @IBOutlet weak var litecoinLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var quantidadeCoinsText: UITextField!
    @IBOutlet weak var precoUnitarioText: UITextField!
    
    var coin: String = "LTC"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        moedaLabel.text = "Litecoin"
        
        carregarBalances(false)
        carregarOrdens(false)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        
        carregarBalances(false)
        carregarOrdens(false)
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.carregarBalances(false)
            self.carregarOrdens(false)
        }
    }

   
    @IBAction func definirMoedaBitcoin(_ sender: Any) {
        coin = "BTC"
        moedaLabel.text = "Bitcoin"
    }
    
    
    @IBAction func definirMoedaBitcoinCash(_ sender: Any) {
        coin = "BCH"
        moedaLabel.text = "BitcoinCash"
    }
    
    
    @IBAction func definirMoedaLitecoin(_ sender: Any) {
        coin = "LTC"
        moedaLabel.text = "Litecoin"
    }
    
    
    @IBAction func atualizarOrdens(_ sender: Any) {
       
        carregarOrdens(true)
    }
    
    @IBAction func atualizarBalances(_ sender: Any) {
         carregarBalances(true)
    }
    
    
    @IBAction func vender(_ sender: Any) {
        let alerta = UIAlertController(title: "Vender", message: "Deseja vender?", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        let confirmar = UIAlertAction(title: "Confirmar", style: .default) { (acao) in
            
            self.ticket.coin = self.coin
            self.ticket.idExchange = self.idExchange
            self.ticket.quantidade = self.quantidadeCoinsText.text
            self.ticket.preco  = self.precoUnitarioText.text
            
            self.service.sellManual(ticketTO: self.ticket)
            
            self.quantidadeCoinsText.text = ""
            self.precoUnitarioText.text = ""
        }
       
        
        alerta.addAction(confirmar)
        alerta.addAction(cancelar)
        
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func comprar(_ sender: Any) {
        let alerta = UIAlertController(title: "Comprar", message: "Deseja comprar?", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        let confirmar = UIAlertAction(title: "Confirmar", style: .default) { (acao) in
           
            self.ticket.coin = self.coin
            self.ticket.idExchange = self.idExchange
            self.ticket.quantidade = self.quantidadeCoinsText.text
            self.ticket.preco  = self.precoUnitarioText.text
            
            self.service.buyManual(ticketTO: self.ticket)
            
            self.quantidadeCoinsText.text = ""
            self.precoUnitarioText.text = ""
        }

        alerta.addAction(confirmar)
        alerta.addAction(cancelar)
        
        present(alerta, animated: true, completion: nil)
        
    }
    
    
    fileprivate func carregarBalances(_ buscarNoServer:Bool) {
        if buscarNoServer {
             service.refreshBalances(idExchange)
        }
        
        if let reaisBalance = self.bitCoinCoreData.getBalanceTO("brl", 1) {
            reaisLabel.text = reaisBalance.available
        }
        if let bitcoinBalance = self.bitCoinCoreData.getBalanceTO("btc", 1) {
            bitcoinLabel.text = bitcoinBalance.available
        }
        if let bitcoinCashBalance = self.bitCoinCoreData.getBalanceTO("bch", 1) {
            bitcoinCashLabel.text = bitcoinCashBalance.available
        }
        if let litecoinBalance = self.bitCoinCoreData.getBalanceTO("ltc", 1) {
            litecoinLabel.text = litecoinBalance.available
        }
    }
    
    fileprivate func carregarOrdens(_ buscarNoServer:Bool) {
        if buscarNoServer {
             service.loadOrdens(idExchange, statusOrdens, coin)
        }
        
        if let idExchangeInt = Int(idExchange) {
            let idExchangeNS = NSNumber(value:idExchangeInt)
             ordensTO = bitCoinCoreData.getOrdensTO(idExchangeNS)!
        }
        self.tableview.reloadData()
    }
    
    //Esconder teclado ao clicar fora
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ordensTO.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! OrdemHeaderTableViewCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! OrdemTableViewCell
        
        if ordensTO.count > 0 {
            cell.coinPairLabel.text = ordensTO[indexPath.row].coin_pair
            cell.limitPriceLabel.text = ordensTO[indexPath.row].limit_price
            cell.orderTypeLabel.text = ordensTO[indexPath.row].order_type
            cell.quantityLabel.text = ordensTO[indexPath.row].quantity
        }
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            let indice = indexPath.row
            let ordemTO = self.ordensTO[indice]
            service.cancelOrdem(ordemTO: ordemTO)
            bitCoinCoreData.deleteOrdem(ordemTO.id!, ordemTO.idExchange!)
            
            self.ordensTO.remove(at: indice) // remove do array
            self.tableview.deleteRows(at: [indexPath], with: .automatic) // remover da tabela
        }
    }
    
    //Metodo executado quando se seleciona uma linha
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.deselectRow(at: indexPath, animated: true)
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
