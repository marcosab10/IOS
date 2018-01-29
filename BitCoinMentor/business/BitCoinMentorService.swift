//
//  BitCoinMentorService.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class BitCoinMentorService {
   
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

                                    self.gerenciarAnalyzes(context, jsonDictionary)
 
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
    
    fileprivate func gerenciarAnalyzes(_ context: NSManagedObjectContext, _ jsonDictionary: [String : AnyObject]) {
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
    
    
}
