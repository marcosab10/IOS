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
    @IBOutlet weak var notificacoesAtivasLabel: UILabel!
    
    
    @IBOutlet weak var bitCoinImage: UIImageView!
    @IBOutlet weak var bitCoinCashImage: UIImageView!
    @IBOutlet weak var liteCoinImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    
    
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
        
        util.bordasImagem(image: bitCoinImage)
        util.bordasImagem(image: bitCoinCashImage)
        util.bordasImagem(image: liteCoinImage)
        util.bordasImagem(image: mainImage)
        
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
    
    func carregarDados() {
        self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/BTC/ticker/", precoLabel: self.precoBitCoinLabel, valorAtual:"valorAtualBitCoin")
        self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/BCH/ticker/", precoLabel: self.precoBitCashLabel, valorAtual: "valorAtualBitCash")
        self.buscarPreco(urlName: "https://www.mercadobitcoin.net/api/LTC/ticker/", precoLabel: self.precoLiteCoinLabel, valorAtual: "valorAtualLiteCoin")
        
        verificarNoficacoesAtivas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0
        var intervaloCalculo:Double = 10
        var contador:Double = 0.0
        
        if let intervalo = UserDefaults.standard.object(forKey: "intervalo") {
            intervaloCalculo = Double(String(describing: intervalo))!
        }
        
        carregarDados()
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            contador = contador + intervaloRefresh
            
             self.carregarDados()
            
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
    
    fileprivate func verificarNoficacoesAtivas(){
        //Testa se a URL existe
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/verifyLiveNotifies?idUser=1") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                     
                        let retorno = String(data: dadosRetorno, encoding: .utf8)
                       
                         DispatchQueue.main.async {
                            if retorno == "Success"{
                                self.notificacoesAtivasLabel.text = "Notificações Ativas"
                            }
                            else{
                                self.notificacoesAtivasLabel.text = ""
                            }
                        }
                    }
                }
                else{
                    print("Erro ao verificar se as notificações estão ativas.")
                }
            }
            tarefa.resume()
        }
    }
    
    func definirAcoes() {
        let taxaLucro:Double = 1 + magemDeLucro / 100
        
        if self.valorAtualBitCoin > self.valorBaseBitCoin * taxaLucro {
            self.acaoBitCoinLabel.text = "Vender"
            //util.notificar(title: "BitCoin", body: "Vender BitCoin")
            
        } else if self.valorAtualBitCoin * taxaLucro < self.valorBaseBitCoin  {
            self.acaoBitCoinLabel.text = "Comprar"
            //util.notificar(title: "BitCoin", body: "Comprar BitCoin")
        }
        else{
            self.acaoBitCoinLabel.text = ""
        }
        
        if self.valorAtualBitCash > self.valorBaseBitCash * taxaLucro {
            self.acaoBitCoinCashLabel.text = "Vender"
            //util.notificar(title: "BitCoinCash", body: "Vender BitCoinCash")
            
        } else if self.valorAtualBitCash * taxaLucro < self.valorBaseBitCash  {
            self.acaoBitCoinCashLabel.text = "Comprar"
           //util.notificar(title: "BitCoinCash", body: "Comprar BitCoinCash")
        }
        else{
            self.acaoBitCoinCashLabel.text = ""
        }
        
        if self.valorAtualLiteCoin > self.valorBaseLiteCoin * taxaLucro {
            self.acaoLiteCoinLabel.text = "Vender"
            //util.notificar(title: "LiteCoin", body: "Vender LiteCoin")
            
        } else if self.valorAtualLiteCoin * taxaLucro < self.valorBaseLiteCoin  {
            self.acaoLiteCoinLabel.text = "Comprar"
            //util.notificar(title: "LiteCoin", body: "Comprar LiteCoin")
        }
        else{
            self.acaoLiteCoinLabel.text = ""
        }
    }
    
    

}

