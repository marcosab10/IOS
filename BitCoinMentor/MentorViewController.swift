//
//  ViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 23/12/17.
//  Copyright © 2017 Marcos Faria. All rights reserved.
//

import UIKit
import Foundation

class MentorViewController: UIViewController {
    
    let util = Util()

    @IBOutlet weak var precoBitCoinLabel: UILabel!
    @IBOutlet weak var precoBitCashLabel: UILabel!
    @IBOutlet weak var precoLiteCoinLabel: UILabel!
    
    @IBOutlet weak var acaoBitCoinLabel: UILabel!
    @IBOutlet weak var acaoBitCoinCashLabel: UILabel!
    @IBOutlet weak var acaoLiteCoinLabel: UILabel!
    
    var valorAtualBitCoin: Double = 0.0
    var valorAtualBitCash: Double = 0.0
    var valorAtualLiteCoin: Double = 0.0
    
    var valorBaseBitCoin: Double = 52000.00
    var valorBaseBitCash: Double = 11000.00
    var valorBaseLiteCoin: Double = 1020.00
    var magemDeLucro: Double = 4.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acaoBitCoinLabel.text = ""
        acaoBitCoinCashLabel.text = ""
        acaoLiteCoinLabel.text = ""
    }
    
    func carregarValoresReferencia() {
        if let bitCoinBase  = UserDefaults.standard.object(forKey: "bitCoinBase") {
            valorBaseBitCoin = bitCoinBase as! Double
        }
        if  let bitCoinCashBase = UserDefaults.standard.object(forKey: "bitCoinCashBase") {
            valorBaseBitCash = bitCoinCashBase as! Double
        }
        if let liteCoinBase = UserDefaults.standard.object(forKey: "liteCoinBase") {
            valorBaseLiteCoin =  liteCoinBase as! Double
        }
        
        if let margem = UserDefaults.standard.object(forKey: "margem") {
            magemDeLucro = margem as! Double
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        let intervaloCalculo:Double = 10
        var contador:Double = 0.0
        
        self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/BTC/ticker/", precoLabel: self.precoBitCoinLabel, valorAtual:"valorAtualBitCoin")
        self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/BCH/ticker/", precoLabel: self.precoBitCashLabel, valorAtual: "valorAtualBitCash")
        self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/LTC/ticker/", precoLabel: self.precoLiteCoinLabel, valorAtual: "valorAtualLiteCoin")
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            contador = contador + intervaloRefresh
            
            self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/BTC/ticker/", precoLabel: self.precoBitCoinLabel, valorAtual: "valorAtualBitCoin")
            self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/BCH/ticker/", precoLabel: self.precoBitCashLabel, valorAtual: "valorAtualBitCash")
            self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/LTC/ticker/", precoLabel: self.precoLiteCoinLabel, valorAtual: "valorAtualLiteCoin")
            
            if (contador == intervaloCalculo){
                contador = 0.0
                self.definirAcoes()
            }
        }
        carregarValoresReferencia()
    }
    
    
    fileprivate func buscarPreco(urlName: String, precoLabel: UILabel, valorAtual: String){
        //Testa se a URL existe
        if let url = URL(string: urlName) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                                if let ticker = objetoJson["ticker"] as? [String: Any] {
                                    if let preco = ticker["last"] as? String {
                                        
                                        if valorAtual == "valorAtualBitCoin"{
                                             self.valorAtualBitCoin = Double(preco)!
                                             UserDefaults.standard.set(objetoJson, forKey: "bitCoinObject")
                                        }
                                        else  if valorAtual == "valorAtualBitCash"{
                                             self.valorAtualBitCash = Double(preco)!
                                             UserDefaults.standard.set(objetoJson, forKey: "bitCoinCashObject")
                                        }
                                        else  if valorAtual == "valorAtualLiteCoin"{
                                            self.valorAtualLiteCoin = Double(preco)!
                                            UserDefaults.standard.set(objetoJson, forKey: "liteCoinObject")
                                        }

                                        DispatchQueue.main.async(execute: {
                                               precoLabel.text = self.util.formatarPreco(preco: NSNumber(value: Double(preco)!))
                                        })
                                    }
                                }
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
    
    func definirAcoes() {
        let taxaLucro:Double = 1 + magemDeLucro / 100
        
        if self.valorAtualBitCoin > self.valorBaseBitCoin * taxaLucro {
            self.acaoBitCoinLabel.text = "Vender"
            
        } else if self.valorAtualBitCoin * taxaLucro < self.valorBaseBitCoin  {
            self.acaoBitCoinLabel.text = "Comprar"
        }
        else{
            self.acaoBitCoinLabel.text = ""
        }
        
        if self.valorAtualBitCash > self.valorBaseBitCash * taxaLucro {
            self.acaoBitCoinCashLabel.text = "Vender"
            //self.notificar(mensagem: "Vender BitCoinCash")
            
        } else if self.valorAtualBitCash * taxaLucro < self.valorBaseBitCash  {
            self.acaoBitCoinCashLabel.text = "Comprar"
            //self.notificar(mensagem: "Comprar BitCoinCash")
        }
        else{
            self.acaoBitCoinCashLabel.text = ""
        }
        
        if self.valorAtualLiteCoin > self.valorBaseLiteCoin * taxaLucro {
            self.acaoLiteCoinLabel.text = "Vender"
            
        } else if self.valorAtualLiteCoin * taxaLucro < self.valorBaseLiteCoin  {
            self.acaoLiteCoinLabel.text = "Comprar"
        }
        else{
            self.acaoLiteCoinLabel.text = ""
        }
    }
    
    func notificar(mensagem: String) {
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type":"application/json",
                                           "Authorization":"key=AAAAGQux7pQ:APA91bGH1SCT0Ey0gLl8CA0-m2eaCzEIz5jhNnJ9kxzuZeDSRWs1IAVamYOcLwYKLdI2rdqUBmDF5qjteRli7ibSaQ_8MhVMu25r9nSU4l5nJGA85qJiv3lDg32W8mrGZo36448q-oD3"]
            request.httpMethod = "POST"
            request.httpBody = "{\"to\":\"fG1meK7JuqQ:APA91bEIG6vgl3qx6PAD4U25lq8515IKWS2t2Hhv3RPcd2RBfVBfg8gmEU3h4J8nfM64QnXum6eIbcNRdK15R8t6DriSeVdlNHxoBEVQ6gSLAiEbIwkLhzwMxaFYnqnjv_TQymS60255\",\"notification\":{\"title\":\"\(mensagem)\"}}".data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, urlresponse, error) in
                if error != nil  {
                    print(error!)
                }
            }).resume()
        }
        
        
    }

}

