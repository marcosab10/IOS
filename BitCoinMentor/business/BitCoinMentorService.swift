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
        let idAnalyzeExchangeDesc:String = String (describing: idAnalyzeExchange)
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/findAnalyzes?idAnalyzeExchange=" + idAnalyzeExchangeDesc) {
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
                    print("Erro ao executar loadAnalyzes.")
                }
            }
            tarefa.resume()
        }
    }
    
    func loadAnalyzeExchange(_ name: String, _ typeCoin: String) {
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/findAnalyzeExchanges?name=" + name + "&typeCoin=" + typeCoin) {
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
                " \"typeCoin\": \"\(analyzeExchangeTO.typeCoin!)\", " +
                " \"activeAnalyzes\": \"\(analyzeExchangeTO.activeAnalyzes!)\", " +
                " \"activeNotification\": \"\(analyzeExchangeTO.activeNotification!)\", " +
                " \"notifyPositive\": \"\(analyzeExchangeTO.notifyPositive!)\", " +
                " \"notifyNegative\": \"\(analyzeExchangeTO.notifyNegative!)\" " +
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
    
    func refreshBalances(_ idExchange: String) {
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/refreshBalances?idExchange=" + idExchange) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let arrayAnalyzes = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [Any]{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                
                                for data in arrayAnalyzes {
                                    let jsonDictionary = data as! Dictionary<String, AnyObject>
                                    
                                    self.bitCoinCoreData.gerenciarBalances(context, jsonDictionary)
                                    
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
    
    func buyManual(ticketTO: TicketTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/buyManual")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"coin\": \"\(ticketTO.coin!)\"," +
                " \"idExchange\": \"\(ticketTO.idExchange!)\", " +
                " \"preco\": \"\(ticketTO.preco!)\", " +
                " \"quantidade\": \"\(ticketTO.quantidade!)\" " +
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
    
    func sellManual(ticketTO: TicketTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/sellManual")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"coin\": \"\(ticketTO.coin!)\"," +
                " \"idExchange\": \"\(ticketTO.idExchange!)\", " +
                " \"preco\": \"\(ticketTO.preco!)\", " +
                " \"quantidade\": \"\(ticketTO.quantidade!)\" " +
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
    
    func loadOrdens(_ idExchange: String, _ status: String, _ coin: String) {
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/findOrdens?idExchange=" + idExchange
            + "&coin=" + coin + "&status=" + status) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let arrayAnalyzes = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [Any]{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                
                                for data in arrayAnalyzes {
                                    let jsonDictionary = data as! Dictionary<String, AnyObject>
                                    
                                    self.bitCoinCoreData.gerenciarOrdens(context, jsonDictionary)
                                    
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
                    print("Erro ao executar findOrdens.")
                }
            }
            tarefa.resume()
        }
    }
    
    
    func cancelOrdem(ordemTO: OrdemTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/cancelOrdem")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"id\": \"\(ordemTO.id!)\"," +
                " \"idExchange\": \"\(ordemTO.idExchange!)\"," +
                " \"createDate\": \"\(ordemTO.createDate!)\"," +
                " \"updateDate\": \"\(ordemTO.updateDate!)\"," +
                " \"order_id\": \"\(ordemTO.order_id!)\"," +
                " \"coin_pair\": \"\(ordemTO.coin_pair!)\"," +
                " \"order_type\": \"\(ordemTO.order_type!)\"," +
                " \"status\": \"\(ordemTO.status!)\"," +
                " \"has_fills\": \"\(ordemTO.has_fills!)\"," +
                " \"quantity\": \"\(ordemTO.quantity!)\"," +
                " \"limit_price\": \"\(ordemTO.limit_price!)\"," +
                " \"executed_quantity\": \"\(ordemTO.executed_quantity!)\", " +
                " \"fee\": \"\(ordemTO.fee!)\", " +
                " \"created_timestamp\": \"\(ordemTO.created_timestamp!)\", " +
                " \"updated_timestamp\": \"\(ordemTO.updated_timestamp!)\" " +
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
    
    
    func buyPriceAuto(ticketTO: TicketTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/buyPriceAuto")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"coin\": \"\(ticketTO.coin!)\"," +
                " \"idExchange\": \"\(ticketTO.idExchange!)\", " +
                " \"modo\": \"\(ticketTO.modoRapido!)\" " +
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
    
    func sellPriceAuto(ticketTO: TicketTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/sellPriceAuto")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"coin\": \"\(ticketTO.coin!)\"," +
                " \"idExchange\": \"\(ticketTO.idExchange!)\", " +
                " \"modo\": \"\(ticketTO.modoRapido!)\" " +
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
    
    func saveAnalyze(analyzeTO: AnalyzeTO){
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/saveAnalyze")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"id\": \"\(analyzeTO.id!)\"," +
                " \"idAnalyzeExchange\": \"\(analyzeTO.idAnalyzeExchange!)\", " +
                " \"timeMinutes\": \"\(analyzeTO.timeMinutes!)\", " +
                " \"percentage\": \"\(analyzeTO.percentage!)\", " +
                " \"createDate\": \"\(analyzeTO.createDate!)\", " +
                " \"updateDate\": \"\(analyzeTO.updateDate!)\", " +
                " \"margin\": \"\(analyzeTO.margin!)\", " +
                " \"activeNotification\": \"\(analyzeTO.activeNotification!)\", " +
                " \"firstPrice\": \"\(analyzeTO.firstPrice!)\", " +
                " \"lastPrice\": \"\(analyzeTO.lastPrice!)\", " +
                " \"notificationInterval\": \"\(analyzeTO.notificationInterval!)\" " +
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
    
    
    
    func deleteAnalyze(_ idAnalyze: String){
        //Testa se a URL existe
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/deleteAnalyze?idAnalyze=" + idAnalyze) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        
                        let retorno = String(data: dadosRetorno, encoding: .utf8)
                        
                        print(retorno)
                    }
                }
                else{
                    print("Erro ao verificar se a análise está ativa.")
                }
            }
            tarefa.resume()
        }
    }
    
    func loadAlarms(_ idExchange: NSNumber) {
        let idExchangeDesc:String = String (describing: idExchange)
        if let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/findAlarms?idExchange=" + idExchangeDesc) {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do{
                            if let arrayAlarms = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [Any]{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                
                                for data in arrayAlarms {
                                    let jsonDictionary = data as! Dictionary<String, AnyObject>
                                    
                                    self.bitCoinCoreData.gerenciarAlarm(context, jsonDictionary)
                                    
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
                    print("Erro ao executar loadAlarms.")
                }
            }
            tarefa.resume()
        }
    }
    
}
