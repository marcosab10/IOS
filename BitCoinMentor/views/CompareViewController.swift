//
//  CompareViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 01/05/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var util = Util()
    var analyzesTOBinance: [AnalyzeTO] = []
    var analyzesTOMercadoBitcoin: [AnalyzeTO] = []
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var timer:Timer?
    var typeCoin:String?
    var typeCoinUS:String?
    
    var analyzeExchangeTOBinance:AnalyzeExchangeTO?
    var analyzeExchangeTOMercadoBitcoin:AnalyzeExchangeTO?
    
    let binance = "Binance"
    let mercadoBitcoin = "MercadoBitcoin"
    
    @IBOutlet weak var precoBinance: UILabel!
    @IBOutlet weak var precoMercadoBitcoin: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
        
        if typeCoin! == "BTC" {
            self.typeCoinUS = "BTCUSDT"
            self.title = "Bitcoin"
        }
        else  if typeCoin! == "BCH" {
            self.typeCoinUS = "BCCUSDT"
            self.title = "Bitcoin Cash"
        }
        else  if typeCoin! == "LTC" {
            self.typeCoinUS = "LTCUSDT"
            self.title = "Litecoin"
        }
        
        
        service.loadAnalyzeExchange(binance, typeCoinUS!)
        service.loadAnalyzeExchange(mercadoBitcoin, typeCoin!)
        
        carregarAnalisesBinance(false)
        carregarAnalisesMercadoBitcoin(false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyzesTOBinance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! CompareTableViewCell
        
        let analyzeTOBinance = self.analyzesTOBinance[indexPath.row]
        let analyzeTOMercadoBitcoin = self.analyzesTOMercadoBitcoin[indexPath.row]
        
        if let timeMinutes = analyzeTOBinance.timeMinutes {
            
            if let percentage = analyzeTOBinance.percentage {
                if let firstPrice = analyzeTOBinance.firstPrice {
                    if let lastPrice = analyzeTOBinance.lastPrice {
                        if let percentageMB = analyzeTOMercadoBitcoin.percentage {
                            if let firstPriceMB = analyzeTOMercadoBitcoin.firstPrice {
                                if let lastPriceMB = analyzeTOMercadoBitcoin.lastPrice {
                                    let timeMinutesText = String(describing: timeMinutes)

                                    precoBinance.text = "USD: " + lastPrice
                                    precoMercadoBitcoin.text = "R$: " + lastPriceMB

                                    celula.intervalo?.text =  timeMinutesText + " Minutos"
                                    celula.precoBinance?.text = firstPrice
                                    celula.porcentagemBinance?.text = percentage + " %  "
                                    
                                    celula.precoMercadoBitcoin?.text = firstPriceMB
                                    celula.porcentagemMercadoBitcoin?.text = percentageMB + " %  "
                                    
                                    let percentageNumber = Double(percentage)
                                    let percentageNumberMB = Double(percentageMB)
                                    
                                    if(percentageNumber! < 0.0){
                                        celula.precoBinance?.textColor = UIColor.red
                                        celula.porcentagemBinance?.textColor = UIColor.red
                                    }
                                    else{
                                        celula.precoBinance?.textColor = UIColor.green
                                        celula.porcentagemBinance?.textColor = UIColor.green
                                    }
                                    
                                    if(percentageNumberMB! < 0.0){
                                        celula.precoMercadoBitcoin?.textColor = UIColor.red
                                        celula.porcentagemMercadoBitcoin?.textColor = UIColor.red
                                        
                                    }
                                    else{
                                        celula.precoMercadoBitcoin?.textColor = UIColor.green
                                        celula.porcentagemMercadoBitcoin?.textColor = UIColor.green
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return celula
    }
   

    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 2.0
        
        carregarAnalisesBinance(false)
        carregarAnalisesMercadoBitcoin(true)
        self.tableview.reloadData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.carregarAnalisesBinance(true)
            self.carregarAnalisesMercadoBitcoin(true)
            self.tableview.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    fileprivate func carregarAnalisesBinance(_ comIntervalo:Bool) {
        if let analyzeExchangeTOBD = self.bitCoinCoreData.getAnalyzeExchangeTO(self.binance, self.typeCoinUS!) {
            self.analyzeExchangeTOBinance = analyzeExchangeTOBD
            
            if self.analyzeExchangeTOBinance != nil {
                self.service.loadAnalyzes((self.analyzeExchangeTOBinance?.id)!)
                if comIntervalo {
                    sleep(1)
                }
                self.analyzesTOBinance = self.bitCoinCoreData.getAnalyzesTO((self.analyzeExchangeTOBinance?.id)!)!
            }
        }
    }
    
    fileprivate func carregarAnalisesMercadoBitcoin(_ comIntervalo:Bool) {
        if let analyzeExchangeTOBD = self.bitCoinCoreData.getAnalyzeExchangeTO(self.mercadoBitcoin, self.typeCoin!) {
            self.analyzeExchangeTOMercadoBitcoin = analyzeExchangeTOBD
            
            if self.analyzeExchangeTOMercadoBitcoin != nil {
                self.service.loadAnalyzes((self.analyzeExchangeTOMercadoBitcoin?.id)!)
                if comIntervalo {
                    sleep(1)
                }
                self.analyzesTOMercadoBitcoin = self.bitCoinCoreData.getAnalyzesTO((self.analyzeExchangeTOMercadoBitcoin?.id)!)!
            }
        }
    }
    
    //Metodo executado quando se seleciona uma linha
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.deselectRow(at: indexPath, animated: true)
    }


}
