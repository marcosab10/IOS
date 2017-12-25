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
    
    
}
