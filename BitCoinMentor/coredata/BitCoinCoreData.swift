//
//  BitCoinCoreData.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 29/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class BitCoinCoreData {
    
    func gerenciarOrdens(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
        let id = jsonDictionary["id"] as! NSNumber
        let idExchange = jsonDictionary["idExchange"] as! NSNumber
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        let order_id = jsonDictionary["order_id"] as! String
        let coin_pair = jsonDictionary["coin_pair"] as! String
        let order_type = jsonDictionary["order_type"] as! String
        let status = jsonDictionary["status"] as! String
        let has_fills = jsonDictionary["has_fills"] as! String
        let quantity = jsonDictionary["quantity"] as! String
        let limit_price = jsonDictionary["limit_price"] as! String
        let executed_quantity = jsonDictionary["executed_quantity"] as! String
        let fee = jsonDictionary["fee"] as! String
        let created_timestamp = jsonDictionary["created_timestamp"] as! String
        let updated_timestamp = jsonDictionary["updated_timestamp"] as! String
        
        if let ordemRetorno = getOrdem(context, id, idExchange) {
            updateOrdem(context, id, idExchange, createDate, updateDate, order_id, coin_pair, order_type, status,
                        has_fills, quantity, limit_price, executed_quantity, fee, created_timestamp, updated_timestamp)
        }
        else{
            insertOrdem(context, id, idExchange, createDate, updateDate, order_id, coin_pair, order_type, status,
                        has_fills, quantity, limit_price, executed_quantity, fee, created_timestamp, updated_timestamp)
        }
    }
    
    fileprivate func insertOrdem(_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ order_id: String, _ coin_pair: String, _ order_type: String, _ status: String,
                                   _ has_fills: String, _ quantity: String, _ limit_price: String, _ executed_quantity: String,
                                   _ fee: String, _ created_timestamp: String, _ updated_timestamp: String) {
        //Cria entidade
        let ordem = NSEntityDescription.insertNewObject(forEntityName: "Ordem", into: context)
        
        ordem.setValue(id, forKey: "id")
        ordem.setValue(idExchange, forKey: "idExchange")
        ordem.setValue(createDate, forKey: "createDate")
        ordem.setValue(updateDate, forKey: "updateDate")
        ordem.setValue(order_id, forKey: "order_id")
        ordem.setValue(coin_pair, forKey: "coin_pair")
        ordem.setValue(order_type, forKey: "order_type")
        ordem.setValue(status, forKey: "status")
        ordem.setValue(has_fills, forKey: "has_fills")
        ordem.setValue(quantity, forKey: "quantity")
        ordem.setValue(limit_price, forKey: "limit_price")
        ordem.setValue(executed_quantity, forKey: "executed_quantity")
        ordem.setValue(fee, forKey: "fee")
        ordem.setValue(created_timestamp, forKey: "created_timestamp")
        ordem.setValue(updated_timestamp, forKey: "updated_timestamp")
    }
    
    fileprivate func updateOrdem(_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber, _ createDate: NSNumber,
                                 _ updateDate: NSNumber, _ order_id: String, _ coin_pair: String, _ order_type: String, _ status: String,
                                 _ has_fills: String, _ quantity: String, _ limit_price: String, _ executed_quantity: String,
                                 _ fee: String, _ created_timestamp: String, _ updated_timestamp: String) {
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Ordem")
        
        let filtroDescricao = NSPredicate(format: "id == %@", id)
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let ordens = try context.fetch(requisicao)
            
            if ordens.count > 0 {
                for ordem in ordens as! [NSManagedObject] {
                    
                    if let id = ordem.value(forKey: "id") {
                        
                        //atualizar
                        ordem.setValue(id, forKey: "id")
                        ordem.setValue(idExchange, forKey: "idExchange")
                        ordem.setValue(createDate, forKey: "createDate")
                        ordem.setValue(updateDate, forKey: "updateDate")
                        ordem.setValue(order_id, forKey: "order_id")
                        ordem.setValue(coin_pair, forKey: "coin_pair")
                        ordem.setValue(order_type, forKey: "order_type")
                        ordem.setValue(status, forKey: "status")
                        ordem.setValue(has_fills, forKey: "has_fills")
                        ordem.setValue(quantity, forKey: "quantity")
                        ordem.setValue(limit_price, forKey: "limit_price")
                        ordem.setValue(executed_quantity, forKey: "executed_quantity")
                        ordem.setValue(fee, forKey: "fee")
                        ordem.setValue(created_timestamp, forKey: "created_timestamp")
                        ordem.setValue(updated_timestamp, forKey: "updated_timestamp")
                        
                    }
                }
            }
            else {
                print("Nenhuma ordem encontrada!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    fileprivate func getOrdem
        (_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber) -> NSManagedObject? {
        var ordemRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Ordem")
        
        let filtroDescricao = NSPredicate(format: "id == %@", id)
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let ordens = try context.fetch(requisicao)
            
            if ordens.count > 0 {
                for ordem in ordens as! [NSManagedObject] {
                    
                    ordemRetorno = ordem
                }
            }
            else {
                print("Nenhuma ordem encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        return ordemRetorno
    }
    
    func listarOrdens(_ idExchange: NSNumber) -> [NSManagedObject] {
        var ordens: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Ordem")
        
        //Ordenar de A-Z a-z ou Z-A
        let ordenacaoAZ = NSSortDescriptor(key: "createDate", ascending: true)
        
        // aplicar filtros criados à requisicao
        requisicao.sortDescriptors = [ordenacaoAZ]
        
        let filtro = NSPredicate(format: "idExchange == %@", idExchange)
        
        requisicao.predicate = filtro
        
        
        do {
            ordens = try context.fetch(requisicao) as! [NSManagedObject]
            
        } catch {
            print("Erro ao recuperar os dados!")
        }
        return ordens
    }
    
    func gerenciarBalances(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
        let id = jsonDictionary["id"] as! NSNumber
        let idExchange = jsonDictionary["idExchange"] as! NSNumber
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        let name = jsonDictionary["name"] as! String
        let available = jsonDictionary["available"] as! String
        let total = jsonDictionary["total"] as! String
        let amountOpenOrders = jsonDictionary["amountOpenOrders"] as! String
       
        
        if let balanceRetorno = getBalance(context, name, idExchange) {
            updateBalance(context, id, idExchange, createDate, updateDate, name, available, total, amountOpenOrders)
        }
        else{
            insertBalance(context, id, idExchange, createDate, updateDate, name, available, total, amountOpenOrders)
        }
        
    }
    
    fileprivate func getBalance
        (_ context: NSManagedObjectContext, _ name: String, _ idExchange: NSNumber) -> NSManagedObject? {
        var balanceRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
        
        
        let filtroDescricao = NSPredicate(format: "name == %@", name)
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let balances = try context.fetch(requisicao)
            
            if balances.count > 0 {
                for balance in balances as! [NSManagedObject] {
                    
                    balanceRetorno = balance
                }
            }
            else {
                print("Nenhum balance encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        return balanceRetorno
    }
    
    
    fileprivate func insertBalance(_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ name: String, _ available: String, _ total: String, _ amountOpenOrders: String) {
        //Cria entidade
        let balance = NSEntityDescription.insertNewObject(forEntityName: "Balance", into: context)
        
        balance.setValue(id, forKey: "id")
        balance.setValue(idExchange, forKey: "idExchange")
        balance.setValue(createDate, forKey: "createDate")
        balance.setValue(updateDate, forKey: "updateDate")
        balance.setValue(name, forKey: "name")
        balance.setValue(available, forKey: "available")
        balance.setValue(total, forKey: "total")
        balance.setValue(amountOpenOrders, forKey: "amountOpenOrders")
    }
    
    fileprivate func updateBalance(_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ name: String, _ available: String, _ total: String, _ amountOpenOrders: String) {
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
        
        let filtroDescricao = NSPredicate(format: "id == %@", id)
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let balances = try context.fetch(requisicao)
            
            if balances.count > 0 {
                for balance in balances as! [NSManagedObject] {
                    
                    if let id = balance.value(forKey: "id") {
                        
                        //atualizar
                        balance.setValue(id, forKey: "id")
                        balance.setValue(idExchange, forKey: "idExchange")
                        balance.setValue(createDate, forKey: "createDate")
                        balance.setValue(updateDate, forKey: "updateDate")
                        balance.setValue(name, forKey: "name")
                        balance.setValue(available, forKey: "available")
                        balance.setValue(total, forKey: "total")
                        balance.setValue(amountOpenOrders, forKey: "amountOpenOrders")
                        
                    }
                }
            }
            else {
                print("Nenhum balance encontrada!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    func getBalanceTO(_ name: String, _ idExchange: NSNumber) -> BalanceTO? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var balanceTO: BalanceTO?
        var balanceRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
        
        let filtroDescricao = NSPredicate(format: "name == %@", name)
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let balances = try context.fetch(requisicao)
            
            if balances.count > 0 {
                for balance in balances as! [NSManagedObject] {
                    
                    balanceRetorno = balance
                }
            }
            else {
                print("Nenhum balance encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        if(balanceRetorno != nil){
            if let id = balanceRetorno.value(forKey: "id"){
                if let idExchange = balanceRetorno.value(forKey: "idExchange") {
                    if let name = balanceRetorno.value(forKey: "name") {
                        if let available = balanceRetorno.value(forKey: "available") {
                            if let total = balanceRetorno.value(forKey: "total") {
                                if let amountOpenOrders = balanceRetorno.value(forKey: "amountOpenOrders") {
                                    
                                    balanceTO = BalanceTO()
                                    
                                    balanceTO?.id = id as? NSNumber
                                    balanceTO?.name = name as? String
                                    balanceTO?.idExchange = idExchange as? NSNumber
                                    balanceTO?.available = available as? String
                                    balanceTO?.total = total as? String
                                    balanceTO?.amountOpenOrders = amountOpenOrders as? String
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return balanceTO
    }
    
    func gerenciarAnalyzes(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
        let id = jsonDictionary["id"] as! NSNumber
        let idAnalyzeExchange = jsonDictionary["idAnalyzeExchange"] as! NSNumber
        let timeMinutes = jsonDictionary["timeMinutes"] as! NSNumber
        let percentage = jsonDictionary["percentage"] as! String
        let typeCoin = jsonDictionary["typeCoin"] as! String
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        let firstPrice = jsonDictionary["firstPrice"] as! String
        let lastPrice = jsonDictionary["lastPrice"] as! String
        
        
        if let analyzeRetorno = getAnalyze(context, timeMinutes, idAnalyzeExchange) {
            updateAnalyze(context, id, idAnalyzeExchange, timeMinutes, percentage, typeCoin, createDate, updateDate, firstPrice, lastPrice)
        }
        else{
            insertAnalyze(context, id, idAnalyzeExchange, timeMinutes, percentage, typeCoin, createDate, updateDate, firstPrice, lastPrice)
        }
    }
    
    
    fileprivate func getAnalyze(_ context: NSManagedObjectContext, _ timeMinutes: NSNumber, _ idAnalyzeExchange: NSNumber) -> NSManagedObject? {
        var analyzeRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Analyze")
        
        
        let filtroDescricao = NSPredicate(format: "timeMinutes == %@", timeMinutes)
        let filtroExchange = NSPredicate(format: "idAnalyzeExchange == %@", idAnalyzeExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let analyzes = try context.fetch(requisicao)
            
            if analyzes.count > 0 {
                for analyze in analyzes as! [NSManagedObject] {
                    
                    analyzeRetorno = analyze
                }
            }
            else {
                print("Nenhum analize encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        return analyzeRetorno
    }
    
    
    fileprivate func insertAnalyze(_ context: NSManagedObjectContext, _ id: NSNumber, _ idAnalyzeExchange: NSNumber,
                                   _ timeMinutes: NSNumber, _ percentage: String, _ typeCoin: String, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ firstPrice: String, _ lastPrice: String) {
        
        //Cria entidade
        let analyze = NSEntityDescription.insertNewObject(forEntityName: "Analyze", into: context)
        
        analyze.setValue(id, forKey: "id")
        analyze.setValue(idAnalyzeExchange, forKey: "idAnalyzeExchange")
        analyze.setValue(timeMinutes, forKey: "timeMinutes")
        analyze.setValue(percentage, forKey: "percentage")
        analyze.setValue(typeCoin, forKey: "typeCoin")
        analyze.setValue(createDate, forKey: "createDate")
        analyze.setValue(updateDate, forKey: "updateDate")
        analyze.setValue(firstPrice, forKey: "firstPrice")
        analyze.setValue(lastPrice, forKey: "lastPrice")
    }
    
    fileprivate func updateAnalyze(_ context: NSManagedObjectContext, _ id: NSNumber, _ idAnalyzeExchange: NSNumber,
                                   _ timeMinutes: NSNumber, _ percentage: String, _ typeCoin: String, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ firstPrice: String, _ lastPrice: String) {
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Analyze")
        
        let filtroDescricao = NSPredicate(format: "timeMinutes == %@", timeMinutes)
        let filtroExchange = NSPredicate(format: "idAnalyzeExchange == %@", idAnalyzeExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange, filtroDescricao])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let analyzes = try context.fetch(requisicao)
            
            if analyzes.count > 0 {
                for analyze in analyzes as! [NSManagedObject] {
                    
                    if let timeMinutes = analyze.value(forKey: "timeMinutes") {
                        
                        //atualizar
                        analyze.setValue(id, forKey: "id")
                        analyze.setValue(idAnalyzeExchange, forKey: "idAnalyzeExchange")
                        analyze.setValue(timeMinutes, forKey: "timeMinutes")
                        analyze.setValue(percentage, forKey: "percentage")
                        analyze.setValue(typeCoin, forKey: "typeCoin")
                        analyze.setValue(createDate, forKey: "createDate")
                        analyze.setValue(updateDate, forKey: "updateDate")
                        analyze.setValue(firstPrice, forKey: "firstPrice")
                        analyze.setValue(lastPrice, forKey: "lastPrice")
                        
                    }
                }
            }
            else {
                print("Nenhuma analyze encontrada!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    func listarAnalyzes(_ idAnalyzeExchange: NSNumber) -> [NSManagedObject] {
        var analyzes: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Analyze")
        
        //Ordenar de A-Z a-z ou Z-A
        let ordenacaoAZ = NSSortDescriptor(key: "timeMinutes", ascending: true)
        
        // aplicar filtros criados à requisicao
        requisicao.sortDescriptors = [ordenacaoAZ]
        
        let filtroExchange = NSPredicate(format: "idAnalyzeExchange == %@", idAnalyzeExchange)
        
        requisicao.predicate = filtroExchange
        
        
        do {
            analyzes = try context.fetch(requisicao) as! [NSManagedObject]
            
        } catch {
            print("Erro ao recuperar os dados!")
        }
        return analyzes
    }
    
    func gerenciarAnalyzeExchange(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
        let id = jsonDictionary["id"] as! NSNumber
        let activeAnalyzes = jsonDictionary["activeAnalyzes"] as! String
        let activeNotification = jsonDictionary["activeNotification"] as! String
        let name = jsonDictionary["name"] as! String
        let token = jsonDictionary["token"] as! String
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        
        
        if let analyzeExchangeRetorno = getAnalyzeExchange(context, id) {
            updateAnalyzeExchange(context, id, activeAnalyzes, activeNotification, name, token, createDate, updateDate)
        }
        else{
            insertAnalyzeExchange(context, id, activeAnalyzes, activeNotification, name, token, createDate, updateDate)
        }
    }
    
    fileprivate func insertAnalyzeExchange(_ context: NSManagedObjectContext, _ id: NSNumber, _ activeAnalyzes: String,
                                   _ activeNotification: String, _ name: String, _ token: String, _ createDate: NSNumber,
                                   _ updateDate: NSNumber) {
        
        //Cria entidade
        let analyzeExchange = NSEntityDescription.insertNewObject(forEntityName: "AnalyzeExchange", into: context)
        
        analyzeExchange.setValue(id, forKey: "id")
        analyzeExchange.setValue(activeAnalyzes, forKey: "activeAnalyzes")
        analyzeExchange.setValue(activeNotification, forKey: "activeNotification")
        analyzeExchange.setValue(name, forKey: "name")
        analyzeExchange.setValue(token, forKey: "token")
        analyzeExchange.setValue(createDate, forKey: "createDate")
        analyzeExchange.setValue(updateDate, forKey: "updateDate")
    }
    
    fileprivate func updateAnalyzeExchange(_ context: NSManagedObjectContext, _ id: NSNumber, _ activeAnalyzes: String,
                                           _ activeNotification: String, _ name: String, _ token: String, _ createDate: NSNumber,
                                           _ updateDate: NSNumber) {
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AnalyzeExchange")
        
        let filtroExchange = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtroExchange
        
        do {
            let analyzes = try context.fetch(requisicao)
            
            if analyzes.count > 0 {
                for analyzeExchange in analyzes as! [NSManagedObject] {
                    
                    if let id = analyzeExchange.value(forKey: "id") {
                        
                        //atualizar
                        analyzeExchange.setValue(id, forKey: "id")
                        analyzeExchange.setValue(activeAnalyzes, forKey: "activeAnalyzes")
                        analyzeExchange.setValue(activeNotification, forKey: "activeNotification")
                        analyzeExchange.setValue(name, forKey: "name")
                        analyzeExchange.setValue(token, forKey: "token")
                        analyzeExchange.setValue(createDate, forKey: "createDate")
                        analyzeExchange.setValue(updateDate, forKey: "updateDate")
                        
                    }
                }
            }
            else {
                print("Nenhuma analyzeExchange encontrada!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    fileprivate func getAnalyzeExchange(_ context: NSManagedObjectContext, _ id: NSNumber) -> NSManagedObject? {
        var analyzeExchangeRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AnalyzeExchange")
        
        let filtroExchange = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtroExchange
        
        do {
            let analyzeExchanges = try context.fetch(requisicao)
            
            if analyzeExchanges.count > 0 {
                for analyzeExchange in analyzeExchanges as! [NSManagedObject] {
                    
                    analyzeExchangeRetorno = analyzeExchange
                }
            }
            else {
                print("Nenhuma analizeExchange encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        return analyzeExchangeRetorno
    }
    
    func getAnalyzeExchangeTO(_ name: String) -> AnalyzeExchangeTO? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var analyzeExchangeTO: AnalyzeExchangeTO?
        var analyzeExchangeRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AnalyzeExchange")
        
        let filtroExchange = NSPredicate(format: "name == %@", name)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtroExchange
        
        do {
            let analyzeExchanges = try context.fetch(requisicao)
            
            if analyzeExchanges.count > 0 {
                for analyzeExchange in analyzeExchanges as! [NSManagedObject] {
                    
                    analyzeExchangeRetorno = analyzeExchange
                }
            }
            else {
                print("Nenhuma analizeExchange encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        if(analyzeExchangeRetorno != nil){
            if let id = analyzeExchangeRetorno.value(forKey: "id"){
                if let name = analyzeExchangeRetorno.value(forKey: "name") {
                    if let activeAnalyzes = analyzeExchangeRetorno.value(forKey: "activeAnalyzes") {
                        if let activeNotification = analyzeExchangeRetorno.value(forKey: "activeNotification") {
                            if let token = analyzeExchangeRetorno.value(forKey: "token") {
                                analyzeExchangeTO = AnalyzeExchangeTO()
                                
                                analyzeExchangeTO?.id = id as? NSNumber
                                analyzeExchangeTO?.name = name as? String
                                analyzeExchangeTO?.activeAnalyzes = activeAnalyzes as? String
                                analyzeExchangeTO?.activeNotification = activeNotification as? String
                                analyzeExchangeTO?.token = token as? String
                            }
                        }
                    }
                }
            }
        }
        
        return analyzeExchangeTO
    }
    
    
    func getOrdensTO(_ idExchange: NSNumber) -> [OrdemTO]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var ordensTO: [OrdemTO] = []
        var ordemRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Ordem")
        
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroExchange])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let ordens = try context.fetch(requisicao)
            
            if ordens.count > 0 {
                for ordem in ordens as! [NSManagedObject] {
                    
                    ordemRetorno = ordem
                    
                    if(ordemRetorno != nil){
                        if let id = ordemRetorno.value(forKey: "id"){
                            if let idExchange = ordemRetorno.value(forKey: "idExchange") {
                                if let createDate = ordemRetorno.value(forKey: "createDate") {
                                    if let updateDate = ordemRetorno.value(forKey: "updateDate") {
                                        if let order_id = ordemRetorno.value(forKey: "order_id") {
                                            if let coin_pair = ordemRetorno.value(forKey: "coin_pair") {
                                                if let order_type = ordemRetorno.value(forKey: "order_type") {
                                                    if let status = ordemRetorno.value(forKey: "status") {
                                                        if let has_fills = ordemRetorno.value(forKey: "has_fills") {
                                                            if let quantity = ordemRetorno.value(forKey: "quantity") {
                                                                if let limit_price = ordemRetorno.value(forKey: "limit_price") {
                                                                    if let executed_quantity = ordemRetorno.value(forKey: "executed_quantity") {
                                                                        if let fee = ordemRetorno.value(forKey: "fee") {
                                                                            if let created_timestamp = ordemRetorno.value(forKey: "created_timestamp") {
                                                                                if let updated_timestamp = ordemRetorno.value(forKey: "updated_timestamp") {
                                                                                    let ordemTO = OrdemTO()
                                                                                    
                                                                                    ordemTO.id = id as?  NSNumber
                                                                                    ordemTO.idExchange = idExchange as? NSNumber
                                                                                    ordemTO.createDate = createDate as? NSNumber
                                                                                    ordemTO.updateDate = updateDate as? NSNumber
                                                                                    ordemTO.order_id = order_id as? String
                                                                                    ordemTO.coin_pair = coin_pair as? String
                                                                                    ordemTO.order_type = order_type as? String
                                                                                    ordemTO.status = status as? String
                                                                                    ordemTO.has_fills = has_fills as? String
                                                                                    ordemTO.quantity = quantity as? String
                                                                                    ordemTO.limit_price = limit_price  as? String
                                                                                    ordemTO.executed_quantity = executed_quantity as? String
                                                                                    ordemTO.fee = fee as? String
                                                                                    ordemTO.created_timestamp = created_timestamp as? String
                                                                                    ordemTO.updated_timestamp = updated_timestamp as? String
                                                                                    
                                                                                    ordensTO.append(ordemTO)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                print("Nenhuma ordem encontrada!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }

        return ordensTO
    }
    
    
}
