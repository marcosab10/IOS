//
//  AnalyzeTO.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class AnalyzeTO {
    
    var id: String
    var idAnalyzeExchange: String
    var timeMinutes: String
    var percentage: String
    var typeCoin: String
    var createDate: String
    var updateDate: String

    // MARK: Inicialização
    init?(id: String, idAnalyzeExchange: String, timeMinutes: String, percentage: String,
          typeCoin: String, createDate: String, updateDate: String) {
        self.id = id
        self.idAnalyzeExchange = idAnalyzeExchange
        self.timeMinutes = timeMinutes
        self.percentage = percentage
        self.typeCoin = typeCoin
        self.createDate = createDate
        self.updateDate = updateDate
    }
}
