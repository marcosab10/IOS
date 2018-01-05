//
//  Util.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/12/17.
//  Copyright © 2017 Marcos Faria. All rights reserved.
//

import Foundation

class Util {
    
    func formatarPreco(preco: NSNumber) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        // nf.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = nf.string(for: preco) {
            return "R$ " + precoFinal
        }
        else{
            return "R$ 0,00"
        }
    }
    
    func definirValorMedio(objetoJson: [String: Any], moeda: String) -> String {
        var retorno = ""
        
        if let ticker = objetoJson["ticker"] as? [String: Any] {
            if let low = ticker["low"] as? String {
                if let high = ticker["high"] as? String {
                    
                    let lowPrice:Double = Double(low)!
                    let highPrice:Double = Double(high)!
                    
                    let precoMedio:Double = (lowPrice + highPrice) / 2.0
                    UserDefaults.standard.set(precoMedio, forKey: moeda)
                    retorno = formatarPreco(preco: NSNumber(value: precoMedio))
                }
            }
        }
        return retorno
    }
    
    
    func definirValorAtual(objetoJson: [String: Any], moeda: String) -> String {
        var retorno = ""
        
        if let ticker = objetoJson["ticker"] as? [String: Any] {
            if let last = ticker["last"] as? String {

                let lastPrice:Double = Double(last)!
                UserDefaults.standard.set(lastPrice, forKey: moeda)
                retorno = formatarPreco(preco: NSNumber(value: lastPrice))
            }
        }
        return retorno
    }
    
    func notificar(title: String, body: String) {
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type":"application/json",
                                           "Authorization":"key=AAAAGQux7pQ:APA91bGH1SCT0Ey0gLl8CA0-m2eaCzEIz5jhNnJ9kxzuZeDSRWs1IAVamYOcLwYKLdI2rdqUBmDF5qjteRli7ibSaQ_8MhVMu25r9nSU4l5nJGA85qJiv3lDg32W8mrGZo36448q-oD3"]
            request.httpMethod = "POST"
            request.httpBody = "{\"to\":\"fG1meK7JuqQ:APA91bEIG6vgl3qx6PAD4U25lq8515IKWS2t2Hhv3RPcd2RBfVBfg8gmEU3h4J8nfM64QnXum6eIbcNRdK15R8t6DriSeVdlNHxoBEVQ6gSLAiEbIwkLhzwMxaFYnqnjv_TQymS60255\",\"notification\":{\"title\":\"\(title)\", \"body\":\"\(body)\", \"sound\":\"default\"}}".data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, urlresponse, error) in
                if error != nil  {
                    print(error!)
                }
            }).resume()
        }
    }
    
    func salvarConfiguracoes(configurationTO: ConfigurationTO) {
        
        let url = URL(string: "http://server20.integrator.com.br:4744/BitCoinMentor-web/BitCoinMentor/saveConfiguration")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.allHTTPHeaderFields = ["Content-Type":"application/json"]
            request.httpMethod = "POST"
            let body: String = "{ " +
                " \"id\": \"\(configurationTO.id!)\"," +
                " \"idUser\": \"\(configurationTO.idUser!)\", " +
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
                " \"notificarLiteCoinVenda\": \"\(configurationTO.notificarLiteCoinVenda!)\" " +
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
