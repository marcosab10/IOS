//
//  BitCoinMentorService.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class BitCoinMentorService {
    
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
   
    func loadAnalyzes(_ idAnalyzeExchange: NSNumber) {
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/findAnalyzes?idAnalyzeExchange=" + String(describing: idAnalyzeExchange)) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let arrayAnalyzes = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [Any]{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                
                                for data in arrayAnalyzes {
                                    let jsonDictionary = data as! Dictionary<String, AnyObject>

                                    self.bitCoinCoreData.gerenciarAnalyzes(context, jsonDictionary)
 
                                }
                                do {
                                    try  context.save()
                                } catch  {
                                    print("Erro ao atualizar dados")
                                }
                            }
                        }catch {
                            print("Erro ao formatar o retorno.")
                        }
                    }
                }
                else{
                    print("Erro ao executar findAnalyzes.")
                }
            }
            tarefa.resume()
        }
    }
    
    func loadAnalyzeExchange(_ name: String) {
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/findAnalyzeExchanges?name=" + name) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let arrayAnalyzes = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [Any]{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                
                                for data in arrayAnalyzes {
                                    let jsonDictionary = data as! Dictionary<String, AnyObject>
                                    
                                    self.bitCoinCoreData.gerenciarAnalyzeExchange(context, jsonDictionary)
                                    
                                }
                                do {
                                    try  context.save()
                                } catch  {
                                    print("Erro ao atualizar dados")
                                }
                            }
                        }catch {
                            print("Erro ao formatar o retorno.")
                        }
                    }
                }
                else{
                    print("Erro ao executar findAnalyzes Exchange.")
                }
            }
            tarefa.resume()
        }
    }
    
    func salvarConfiguracoes(configurationTO: ConfigurationTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/saveConfiguration")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"id\": \"\(configurationTO.id!)\"," +
                " \"idExchange\": \"\(configurationTO.idExchange!)\", " +
                " \"name\": \"\(configurationTO.name!)\", " +
                " \"valorBaseBitCoin\": \"\(configurationTO.valorBaseBitCoin!)\", " +
                " \"valorBaseBitcoinCash\": \"\(configurationTO.valorBaseBitcoinCash!)\", " +
                " \"valorBaseLiteCoin\": \"\(configurationTO.valorBaseLiteCoin!)\", " +
                " \"margem\": \"\(configurationTO.margem!)\", " +
                " \"intervalo\": \"\(configurationTO.intervalo!)\", " +
                " \"notificarBitcoinCompra\": \"\(configurationTO.notificarBitcoinCompra!)\", " +
                " \"notificarBitcoinCashCompra\": \"\(configurationTO.notificarBitcoinCashCompra!)\", " +
                " \"notificarLiteCoinCompra\": \"\(configurationTO.notificarLiteCoinCompra!)\", " +
                " \"notificarBitcoinVenda\": \"\(configurationTO.notificarBitcoinVenda!)\", " +
                " \"notificarBitcoinCashVenda\": \"\(configurationTO.notificarBitcoinCashVenda!)\", " +
                " \"notificarLiteCoinVenda\": \"\(configurationTO.notificarLiteCoinVenda!)\", " +
                " \"notificacoesLigadas\": \"\(configurationTO.notificacoesHabilitadas!)\", " +
                " \"token\": \"\(configurationTO.token!)\" " +
            "}"
            request.httpBody = body.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil  {
                    print(error!)
                }
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        print(stringData) //JSONSerialization
                    }
                }
            })
            task.resume()
        }
    }
    
    func saveAnalyzeExchange(analyzeExchangeTO: AnalyzeExchangeTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/saveAnalyzeExchange")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"id\": \"\(analyzeExchangeTO.id!)\"," +
                " \"name\": \"\(analyzeExchangeTO.name!)\", " +
                " \"token\": \"\(analyzeExchangeTO.token!)\", " +
                " \"activeAnalyzes\": \"\(analyzeExchangeTO.activeAnalyzes!)\", " +
                " \"activeNotification\": \"\(analyzeExchangeTO.activeNotification!)\" " +
            "}"
            request.httpBody = body.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil  {
                    print(error!)
                }
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        print(stringData) //JSONSerialization
                    }
                }
            })
            task.resume()
        }
    }
    
    
}
