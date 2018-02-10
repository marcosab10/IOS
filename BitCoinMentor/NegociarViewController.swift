//
//  NegociarViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 07/02/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class NegociarViewController: UIViewController {
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    
    @IBOutlet weak var reaisLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var bitcoinCashLabel: UILabel!
    @IBOutlet weak var litecoinLabel: UILabel!
    

    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var quantidadeCoinsText: UITextField!
    @IBOutlet weak var precoUnitarioText: UITextField!
    
    var coin: String = "LTC"
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moedaLabel.text = "Litecoin"
        
        carregarBalances()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carregarBalances()
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
    
    
    @IBAction func atualizar(_ sender: Any) {
        carregarBalances()
    }
    
    
    
    @IBAction func vender(_ sender: Any) {
        
        
    }
    
    @IBAction func comprar(_ sender: Any) {
        
        
    }
    
    
    fileprivate func carregarBalances() {
        service.refreshBalances("1")
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
