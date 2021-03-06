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
    
    func deleteOrdem(_ id: NSNumber, _ idExchange: NSNumber){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
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
                    
                    context.delete(ordem)
                }
            }
            else {
                print("Nenhuma ordem encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
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
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        let firstPrice = jsonDictionary["firstPrice"] as! String
        let lastPrice = jsonDictionary["lastPrice"] as! String
        let activeNotification = jsonDictionary["activeNotification"] as! String
        let notificationInterval = jsonDictionary["notificationInterval"] as! NSNumber
        let margin = jsonDictionary["margin"] as! String
        
        
        if let analyzeRetorno = getAnalyze(context, timeMinutes, idAnalyzeExchange) {
            updateAnalyze(context, id, idAnalyzeExchange, timeMinutes, percentage, createDate, updateDate, firstPrice, lastPrice, activeNotification, notificationInterval, margin)
        }
        else{
            insertAnalyze(context, id, idAnalyzeExchange, timeMinutes, percentage, createDate, updateDate, firstPrice, lastPrice, activeNotification, notificationInterval, margin)
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
                                   _ timeMinutes: NSNumber, _ percentage: String, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ firstPrice: String, _ lastPrice: String, _ activeNotification: String,
                                   _ notificationInterval: NSNumber, _ margin: String) {
        
        //Cria entidade
        let analyze = NSEntityDescription.insertNewObject(forEntityName: "Analyze", into: context)
        
        analyze.setValue(id, forKey: "id")
        analyze.setValue(idAnalyzeExchange, forKey: "idAnalyzeExchange")
        analyze.setValue(timeMinutes, forKey: "timeMinutes")
        analyze.setValue(percentage, forKey: "percentage")
        analyze.setValue(createDate, forKey: "createDate")
        analyze.setValue(updateDate, forKey: "updateDate")
        analyze.setValue(firstPrice, forKey: "firstPrice")
        analyze.setValue(lastPrice, forKey: "lastPrice")
        analyze.setValue(activeNotification, forKey: "activeNotification")
        analyze.setValue(notificationInterval, forKey: "notificationInterval")
        analyze.setValue(margin, forKey: "margin")
    }
    
    fileprivate func updateAnalyze(_ context: NSManagedObjectContext, _ id: NSNumber, _ idAnalyzeExchange: NSNumber,
                                   _ timeMinutes: NSNumber, _ percentage: String, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ firstPrice: String, _ lastPrice: String, _ activeNotification: String,
                                   _ notificationInterval: NSNumber, _ margin: String) {
        
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
                        analyze.setValue(createDate, forKey: "createDate")
                        analyze.setValue(updateDate, forKey: "updateDate")
                        analyze.setValue(firstPrice, forKey: "firstPrice")
                        analyze.setValue(lastPrice, forKey: "lastPrice")
                        analyze.setValue(activeNotification, forKey: "activeNotification")
                        analyze.setValue(notificationInterval, forKey: "notificationInterval")
                        analyze.setValue(margin, forKey: "margin")
                        
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
    
    func getAnalyzesTO(_ idAnalyzeExchange: NSNumber) -> [AnalyzeTO]? {
        var analyzesTO: [AnalyzeTO] = []
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
            
            let analyzes = try context.fetch(requisicao)
            
            if analyzes.count > 0 {
                for analyze in analyzes as! [NSManagedObject] {
                    
                    if let id = analyze.value(forKey: "id"){
                        if let idAnalyzeExchange = analyze.value(forKey: "idAnalyzeExchange"){
                            if let createDate = analyze.value(forKey: "createDate"){
                                if let updateDate = analyze.value(forKey: "updateDate"){
                                    if let timeMinutes = analyze.value(forKey: "timeMinutes"){
                                        if let percentage = analyze.value(forKey: "percentage"){
                                            if let margin = analyze.value(forKey: "margin"){
                                                if let activeNotification = analyze.value(forKey: "activeNotification"){
                                                    if let firstPrice = analyze.value(forKey: "firstPrice"){
                                                        if let lastPrice = analyze.value(forKey: "lastPrice"){
                                                            if let notificationInterval = analyze.value(forKey: "notificationInterval"){
                                                                let analyzeTO = AnalyzeTO()
                                                                
                                                                analyzeTO.id = id as?  NSNumber
                                                                analyzeTO.idAnalyzeExchange = idAnalyzeExchange as? NSNumber
                                                                analyzeTO.createDate = createDate as? NSNumber
                                                                analyzeTO.updateDate = updateDate as? NSNumber
                                                                analyzeTO.timeMinutes = timeMinutes as? NSNumber
                                                                analyzeTO.percentage = percentage as? String
                                                                analyzeTO.margin = margin as? String
                                                                analyzeTO.activeNotification = activeNotification as? String
                                                                analyzeTO.firstPrice = firstPrice as? String
                                                                analyzeTO.lastPrice = lastPrice as? String
                                                                analyzeTO.notificationInterval = notificationInterval as? NSNumber
                                                                
                                                                analyzesTO.append(analyzeTO)
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
        } catch {
            print("Erro ao recuperar os dados!")
        }
        return analyzesTO
    }
    
    
    func deleteAnalyze(_ id: NSNumber){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Analyze")
        
        let filtro = NSPredicate(format: "id == %@", id)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtro])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let analyzes = try context.fetch(requisicao)
            
            if analyzes.count > 0 {
                for analyze in analyzes as! [NSManagedObject] {
                    
                    context.delete(analyze)
                }
            }
            else {
                print("Nenhuma analyze encontrada!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    
    func gerenciarAnalyzeExchange(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
        let id = jsonDictionary["id"] as! NSNumber
        let activeAnalyzes = jsonDictionary["activeAnalyzes"] as! String
        let activeNotification = jsonDictionary["activeNotification"] as! String
        let name = jsonDictionary["name"] as! String
        let token = jsonDictionary["token"] as! String
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        let typeCoin = jsonDictionary["typeCoin"] as! String
        let notifyPositive = jsonDictionary["notifyPositive"] as! String
        let notifyNegative = jsonDictionary["notifyNegative"] as! String
        
        if let analyzeExchangeRetorno = getAnalyzeExchange(context, id) {
            updateAnalyzeExchange(context, id, activeAnalyzes, activeNotification, name, token, createDate, updateDate, typeCoin, notifyPositive, notifyNegative)
        }
        else{
            insertAnalyzeExchange(context, id, activeAnalyzes, activeNotification, name, token, createDate, updateDate, typeCoin, notifyPositive, notifyNegative)
        }
    }
    
    fileprivate func insertAnalyzeExchange(_ context: NSManagedObjectContext, _ id: NSNumber, _ activeAnalyzes: String,
                                   _ activeNotification: String, _ name: String, _ token: String, _ createDate: NSNumber,
                                   _ updateDate: NSNumber, _ typeCoin: String, _ notifyPositive:String, _ notifyNegative:String) {
        
        //Cria entidade
        let analyzeExchange = NSEntityDescription.insertNewObject(forEntityName: "AnalyzeExchange", into: context)
        
        analyzeExchange.setValue(id, forKey: "id")
        analyzeExchange.setValue(activeAnalyzes, forKey: "activeAnalyzes")
        analyzeExchange.setValue(activeNotification, forKey: "activeNotification")
        analyzeExchange.setValue(name, forKey: "name")
        analyzeExchange.setValue(token, forKey: "token")
        analyzeExchange.setValue(createDate, forKey: "createDate")
        analyzeExchange.setValue(updateDate, forKey: "updateDate")
        analyzeExchange.setValue(typeCoin, forKey: "typeCoin")
        analyzeExchange.setValue(notifyPositive, forKey: "notifyPositive")
        analyzeExchange.setValue(notifyNegative, forKey: "notifyNegative")
    }
    
    fileprivate func updateAnalyzeExchange(_ context: NSManagedObjectContext, _ id: NSNumber, _ activeAnalyzes: String,
                                           _ activeNotification: String, _ name: String, _ token: String, _ createDate: NSNumber,
                                           _ updateDate: NSNumber, _ typeCoin: String, _ notifyPositive:String, _ notifyNegative:String) {
        
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
                        analyzeExchange.setValue(typeCoin, forKey: "typeCoin")
                        analyzeExchange.setValue(notifyPositive, forKey: "notifyPositive")
                        analyzeExchange.setValue(notifyNegative, forKey: "notifyNegative")
                        
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
    
    func getAnalyzeExchangeTO(_ name: String, _ typeCoin: String) -> AnalyzeExchangeTO? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var analyzeExchangeTO: AnalyzeExchangeTO?
        var analyzeExchangeRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AnalyzeExchange")

        // aplicar filtros criados à requisicao
        let filtroName = NSPredicate(format: "name == %@", name)
        let filtroTypeCoin = NSPredicate(format: "typeCoin == %@", typeCoin)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtroName, filtroTypeCoin])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
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
                                if let typeCoin = analyzeExchangeRetorno.value(forKey: "typeCoin") {
                                    if let notifyPositive = analyzeExchangeRetorno.value(forKey: "notifyPositive") {
                                        if let notifyNegative = analyzeExchangeRetorno.value(forKey: "notifyNegative") {
                                            
                                            analyzeExchangeTO = AnalyzeExchangeTO()
                                            
                                            analyzeExchangeTO?.id = id as? NSNumber
                                            analyzeExchangeTO?.name = name as? String
                                            analyzeExchangeTO?.activeAnalyzes = activeAnalyzes as? String
                                            analyzeExchangeTO?.activeNotification = activeNotification as? String
                                            analyzeExchangeTO?.token = token as? String
                                            analyzeExchangeTO?.typeCoin = typeCoin as? String
                                            analyzeExchangeTO?.notifyPositive = notifyPositive as? String
                                            analyzeExchangeTO?.notifyNegative = notifyNegative as? String
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return analyzeExchangeTO
    }
    
    
    //Alarms  
    
    func gerenciarAlarm(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {

        let id = jsonDictionary["id"] as! NSNumber
        let idExchange = jsonDictionary["idExchange"] as! NSNumber
        let coin = jsonDictionary["coin"] as! String
        let price = jsonDictionary["price"] as! String
        let orientation = jsonDictionary["orientation"] as! String
        let activeNotification = jsonDictionary["activeNotification"] as! String
        let notificationInterval = jsonDictionary["notificationInterval"] as! NSNumber
        let notificationNumber = jsonDictionary["notificationNumber"] as! NSNumber
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        let token = jsonDictionary["token"] as! String
        let repeatAlarm = jsonDictionary["repeatAlarm"] as! String
        
        
        if let alarmRetorno = getAlarm(context, id) {
            updateAlarm(context, id, idExchange, coin, price, orientation, activeNotification, notificationInterval, notificationNumber, createDate, updateDate, token, repeatAlarm)
        }
        else{
            insertAlarm(context, id, idExchange, coin, price, orientation, activeNotification, notificationInterval, notificationNumber, createDate, updateDate, token, repeatAlarm)
        }
    }
    
    fileprivate func insertAlarm(_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber, _ coin: String, _ price: String, _ orientation: String, _ activeNotification: String, _ notificationInterval: NSNumber, _ notificationNumber: NSNumber, _ createDate: NSNumber, _ updateDate: NSNumber, _ token: String, _ repeatAlarm: String) {
        
        //Cria entidade
        let alarm = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: context)
        
        alarm.setValue(id, forKey: "id")
        alarm.setValue(idExchange, forKey: "idExchange")
        alarm.setValue(coin, forKey: "coin")
        alarm.setValue(price, forKey: "price")
        alarm.setValue(orientation, forKey: "orientation")
        alarm.setValue(activeNotification, forKey: "activeNotification")
        alarm.setValue(notificationInterval, forKey: "notificationInterval")
        alarm.setValue(notificationNumber, forKey: "notificationNumber")
        alarm.setValue(createDate, forKey: "createDate")
        alarm.setValue(updateDate, forKey: "updateDate")
        alarm.setValue(token, forKey: "token")
        alarm.setValue(repeatAlarm, forKey: "repeatAlarm")
    }
    
    fileprivate func updateAlarm(_ context: NSManagedObjectContext, _ id: NSNumber, _ idExchange: NSNumber, _ coin: String, _ price: String, _ orientation: String, _ activeNotification: String, _ notificationInterval: NSNumber, _ notificationNumber: NSNumber, _ createDate: NSNumber, _ updateDate: NSNumber, _ token: String, _ repeatAlarm: String) {
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
        
        let filtroExchange = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtroExchange
        
        do {
            let analyzes = try context.fetch(requisicao)
            
            if analyzes.count > 0 {
                for alarm in analyzes as! [NSManagedObject] {
                    
                    if let id = alarm.value(forKey: "id") {
                        
                        //atualizar
                        alarm.setValue(id, forKey: "id")
                        alarm.setValue(idExchange, forKey: "idExchange")
                        alarm.setValue(coin, forKey: "coin")
                        alarm.setValue(price, forKey: "price")
                        alarm.setValue(orientation, forKey: "orientation")
                        alarm.setValue(activeNotification, forKey: "activeNotification")
                        alarm.setValue(notificationInterval, forKey: "notificationInterval")
                        alarm.setValue(notificationNumber, forKey: "notificationNumber")
                        alarm.setValue(createDate, forKey: "createDate")
                        alarm.setValue(updateDate, forKey: "updateDate")
                        alarm.setValue(token, forKey: "token")
                        alarm.setValue(repeatAlarm, forKey: "repeatAlarm")
                        
                    }
                }
            }
            else {
                print("Nenhum alarme encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    fileprivate func getAlarm(_ context: NSManagedObjectContext, _ id: NSNumber) -> NSManagedObject? {
        var alarmRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
        
        let filtro = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtro
        
        do {
            let alarms = try context.fetch(requisicao)
            
            if alarms.count > 0 {
                for alarm in alarms as! [NSManagedObject] {
                    
                    alarmRetorno = alarm
                }
            }
            else {
                print("Nenhum alarme encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        return alarmRetorno
    }
    
    func getAlarmTO(_ id: NSNumber) -> AlarmTO? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var alarm: AlarmTO?
        var alarmRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
        
        // aplicar filtros criados à requisicao
        let filtro = NSPredicate(format: "id == %@", id)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtro])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let alarms = try context.fetch(requisicao)
            
            if alarms.count > 0 {
                for alarm in alarms as! [NSManagedObject] {
                    
                    alarmRetorno = alarm
                }
            }
            else {
                print("Nenhum alarme encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        if(alarmRetorno != nil){
            if let id = alarmRetorno.value(forKey: "id"){
                if let idExchange = alarmRetorno.value(forKey: "idExchange") {
                    if let coin = alarmRetorno.value(forKey: "coin") {
                        if let price = alarmRetorno.value(forKey: "price") {
                            if let orientation = alarmRetorno.value(forKey: "orientation") {
                                if let activeNotification = alarmRetorno.value(forKey: "activeNotification") {
                                    if let notificationInterval = alarmRetorno.value(forKey: "notificationInterval") {
                                        if let notificationNumber = alarmRetorno.value(forKey: "notificationNumber") {
                                            if let createDate = alarmRetorno.value(forKey: "createDate") {
                                                if let updateDate = alarmRetorno.value(forKey: "updateDate") {
                                                    if let token = alarmRetorno.value(forKey: "token") {
                                                        if let repeatAlarm = alarmRetorno.value(forKey: "repeatAlarm") {
                                            
                                                            alarm = AlarmTO()
                                                            
                                                            alarm?.id = id as? NSNumber
                                                            alarm?.idExchange = idExchange as? NSNumber
                                                            alarm?.coin = coin as? String
                                                            alarm?.price = price as? String
                                                            alarm?.orientation = orientation as? String
                                                            alarm?.activeNotification = activeNotification as? String
                                                            alarm?.notificationInterval = notificationInterval as? NSNumber
                                                            alarm?.notificationNumber = notificationNumber as? NSNumber
                                                            alarm?.createDate = createDate as? NSNumber
                                                            alarm?.updateDate = updateDate as? NSNumber
                                                            alarm?.token = token as? String
                                                            alarm?.repeatAlarm = repeatAlarm as? String
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
        return alarm
    }
    
    
    func getAlarmsTO(_ idExchange: NSNumber) -> [AlarmTO]? {
        var alarmsTO: [AlarmTO] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
        
        //Ordenar de A-Z a-z ou Z-A
        let ordenacaoAZ = NSSortDescriptor(key: "coin", ascending: true)
        
        // aplicar filtros criados à requisicao
        requisicao.sortDescriptors = [ordenacaoAZ]
        
        let filtroExchange = NSPredicate(format: "idExchange == %@", idExchange)
        
        requisicao.predicate = filtroExchange
        
        do {
            
            let alarms = try context.fetch(requisicao)
            
            if alarms.count > 0 {
                for alarmRetorno in alarms as! [NSManagedObject] {
                    if let id = alarmRetorno.value(forKey: "id"){
                        if let idExchange = alarmRetorno.value(forKey: "idExchange") {
                            if let coin = alarmRetorno.value(forKey: "coin") {
                                if let price = alarmRetorno.value(forKey: "price") {
                                    if let orientation = alarmRetorno.value(forKey: "orientation") {
                                        if let activeNotification = alarmRetorno.value(forKey: "activeNotification") {
                                            if let notificationInterval = alarmRetorno.value(forKey: "notificationInterval") {
                                                if let notificationNumber = alarmRetorno.value(forKey: "notificationNumber") {
                                                    if let createDate = alarmRetorno.value(forKey: "createDate") {
                                                        if let updateDate = alarmRetorno.value(forKey: "updateDate") {
                                                            if let token = alarmRetorno.value(forKey: "token") {
                                                                if let repeatAlarm = alarmRetorno.value(forKey: "repeatAlarm") {
                                                               let alarmTO = AlarmTO()
                                                                
                                                                alarmTO.id = id as? NSNumber
                                                                alarmTO.idExchange = idExchange as? NSNumber
                                                                alarmTO.coin = coin as? String
                                                                alarmTO.price = price as? String
                                                                alarmTO.orientation = orientation as? String
                                                                alarmTO.activeNotification = activeNotification as? String
                                                                alarmTO.notificationInterval = notificationInterval as? NSNumber
                                                                alarmTO.notificationNumber = notificationNumber as? NSNumber
                                                                alarmTO.createDate = createDate as? NSNumber
                                                                alarmTO.updateDate = updateDate as? NSNumber
                                                                alarmTO.token = token as? String
                                                                alarmTO.repeatAlarm = repeatAlarm as? String
                                                                
                                                                alarmsTO.append(alarmTO)
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
            
        } catch {
            print("Erro ao recuperar os dados!")
        }
        return alarmsTO
    }
    
    func deleteAlarm(_ id: NSNumber){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
        
        let filtro = NSPredicate(format: "id == %@", id)
        
        let combinacaoFiltro = NSCompoundPredicate(andPredicateWithSubpredicates: [filtro])
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = combinacaoFiltro
        
        do {
            let alarms = try context.fetch(requisicao)
            
            if alarms.count > 0 {
                for alarm in alarms as! [NSManagedObject] {
                    
                    context.delete(alarm)
                }
            }
            else {
                print("Nenhum alarme encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    
    // AlarmControl
    
    func gerenciarAlarmControl(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
        let id = jsonDictionary["id"] as! NSNumber
        let notifyAlarm = jsonDictionary["notifyAlarm"] as! String
        let createDate = jsonDictionary["createDate"] as! NSNumber
        let updateDate = jsonDictionary["updateDate"] as! NSNumber
        
        if let analyzeExchangeRetorno = getAnalyzeExchange(context, id) {
            updateAlarmControl(context, id, notifyAlarm, createDate, updateDate)
        }
        else{
            insertAlarmControl(context, id, notifyAlarm, createDate, updateDate)
        }
    }
    
    fileprivate func insertAlarmControl(_ context: NSManagedObjectContext, _ id: NSNumber, _ notifyAlarm: String,
                                        _ createDate: NSNumber, _ updateDate: NSNumber) {
        
        //Cria entidade
        let alarmControl = NSEntityDescription.insertNewObject(forEntityName: "AlarmControl", into: context)
        
        alarmControl.setValue(id, forKey: "id")
        alarmControl.setValue(notifyAlarm, forKey: "notifyAlarm")
        alarmControl.setValue(createDate, forKey: "createDate")
        alarmControl.setValue(updateDate, forKey: "updateDate")
    }
    
    fileprivate func updateAlarmControl(_ context: NSManagedObjectContext, _ id: NSNumber, _ notifyAlarm: String,
                                        _ createDate: NSNumber, _ updateDate: NSNumber) {
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmControl")
        
        let filtro = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtro
        
        do {
            let alarmControls = try context.fetch(requisicao)
            
            if alarmControls.count > 0 {
                for alarmControl in alarmControls as! [NSManagedObject] {
                    
                    if let id = alarmControl.value(forKey: "id") {
                        
                        //atualizar
                        alarmControl.setValue(id, forKey: "id")
                        alarmControl.setValue(notifyAlarm, forKey: "notifyAlarm")
                        alarmControl.setValue(createDate, forKey: "createDate")
                        alarmControl.setValue(updateDate, forKey: "updateDate")
                    }
                }
            }
            else {
                print("Nenhum alarmControl encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
    }
    
    fileprivate func getAlarmControl(_ context: NSManagedObjectContext, _ id: NSNumber) -> NSManagedObject? {
        var alarmControlRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmControl")
        
        let filtro = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtro
        
        do {
            let alarmControls = try context.fetch(requisicao)
            
            if alarmControls.count > 0 {
                for alarmControl in alarmControls as! [NSManagedObject] {
                    
                    alarmControlRetorno = alarmControl
                }
            }
            else {
                print("Nenhum alarmControl encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        return alarmControlRetorno
    }
    
    func getAlarmControlTO(_ id: NSNumber) -> AlarmControlTO? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var alarmControlTO: AlarmControlTO?
        var alarmControlRetorno: NSManagedObject!
        
        //Criar uma requisição
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmControl")
        
        let filtro = NSPredicate(format: "id == %@", id)
        
        // aplicar filtros criados à requisicao
        requisicao.predicate = filtro
        
        do {
            let alarmControls = try context.fetch(requisicao)
            
            if alarmControls.count > 0 {
                for alarmControl in alarmControls as! [NSManagedObject] {
                    
                    alarmControlRetorno = alarmControl
                }
            }
            else {
                print("Nenhum alarmControl encontrado!")
            }
        } catch {
            print("Erro ao recuperar os dados!")
        }
        
        if(alarmControlRetorno != nil){
            if let id = alarmControlRetorno.value(forKey: "id"){
                if let notifyAlarm = alarmControlRetorno.value(forKey: "notifyAlarm") {
                    
                    alarmControlTO = AlarmControlTO()
                    
                    alarmControlTO?.id = id as? NSNumber
                    alarmControlTO?.notifyAlarm = notifyAlarm as? String
                }
            }
        }
        
        return alarmControlTO
    }
    
}
