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
        var analyzeExchangeTO: AnalyzeExchangeTO!
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
                                
                                analyzeExchangeTO.id = id as? NSNumber
                                analyzeExchangeTO.name = name as? String
                                analyzeExchangeTO.activeAnalyzes = activeAnalyzes as? String
                                analyzeExchangeTO.activeNotification = activeNotification as? String
                                analyzeExchangeTO.token = token as? String
                            }
                        }
                    }
                }
            }
        }
        
        return analyzeExchangeTO
    }
    
    
}
