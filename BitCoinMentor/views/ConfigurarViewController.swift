//
//  ConfigurarViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/12/17.
//  Copyright © 2017 Marcos Faria. All rights reserved.
//

import UIKit

class ConfigurarViewController: UIViewController {
    let service: BitCoinMentorService = BitCoinMentorService()
    let util = Util()

    @IBOutlet weak var bitCoinBaseLabel: UILabel!
    @IBOutlet weak var bitCoinCashBaseLabel: UILabel!
    @IBOutlet weak var liteCoinBaseLabel: UILabel!
    @IBOutlet weak var margemLabel: UILabel!
    @IBOutlet weak var intervaloLabel: UILabel!
    
    
    @IBOutlet weak var bitCoinBaseText: UITextField!
    @IBOutlet weak var bitCoinCashBaseText: UITextField!
    @IBOutlet weak var liteCoinBaseText: UITextField!
    @IBOutlet weak var margemText: UITextField!
    @IBOutlet weak var intervaloText: UITextField!
    
    @IBOutlet weak var notifBitcoinVendaSwitch: UISwitch!
    @IBOutlet weak var notifBitcoinCompraSwitch: UISwitch!
    @IBOutlet weak var notifBitcoinCashVendaSwitch: UISwitch!
    @IBOutlet weak var notifBitcoinCashCompraSwitch: UISwitch!
    @IBOutlet weak var notifLitecoinVendaSwitch: UISwitch!
    @IBOutlet weak var notifLitecoinCompraSwitch: UISwitch!
    @IBOutlet weak var notificacoesHabilitadasSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carregarValoresReferencia()
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        UserDefaults.standard.set(notifBitcoinVendaSwitch.isOn, forKey: "notifBitcoinVendaSwitch")
        UserDefaults.standard.set(notifBitcoinCompraSwitch.isOn, forKey: "notifBitcoinCompraSwitch")
        UserDefaults.standard.set(notifBitcoinCashVendaSwitch.isOn, forKey: "notifBitcoinCashVendaSwitch")
        UserDefaults.standard.set(notifBitcoinCashCompraSwitch.isOn, forKey: "notifBitcoinCashCompraSwitch")
        UserDefaults.standard.set(notifLitecoinVendaSwitch.isOn, forKey: "notifLitecoinVendaSwitch")
        UserDefaults.standard.set(notifLitecoinCompraSwitch.isOn, forKey: "notifLitecoinCompraSwitch")
        UserDefaults.standard.set(notificacoesHabilitadasSwitch.isOn, forKey: "notificacoesHabilitadasSwitch")
        
        
        
        let configurationTO = ConfigurationTO()
        configurationTO.id = "1"
        configurationTO.idExchange = "1"
        configurationTO.name = "MercadoBitCoin"
        
        if let bitCoinBase  = UserDefaults.standard.object(forKey: "bitCoinBase") {
            let bitCoinBaseDouble = bitCoinBase as! Double
            configurationTO.valorBaseBitCoin = String(bitCoinBaseDouble)
        }
        if  let bitCoinCashBase = UserDefaults.standard.object(forKey: "bitCoinCashBase") {
            let bitCoinCashBaseDouble = bitCoinCashBase as! Double
            configurationTO.valorBaseBitcoinCash = String(bitCoinCashBaseDouble)
        }
        if let liteCoinBase = UserDefaults.standard.object(forKey: "liteCoinBase") {
            let liteCoinBaseDouble = liteCoinBase as! Double
           configurationTO.valorBaseLiteCoin = String(liteCoinBaseDouble)
        }
        if let margem = UserDefaults.standard.object(forKey: "margem") {
            let margemDouble = margem as! Int
            configurationTO.margem = String(margemDouble)
        }
        if let intervalo = UserDefaults.standard.object(forKey: "intervalo") {
            let intervaloDouble = intervalo as! Int
            configurationTO.intervalo = String(intervaloDouble)
        }
        if let notificacoesHabilitadasSwitchValue = UserDefaults.standard.object(forKey: "notificacoesHabilitadasSwitch") {
            let notificacoesHabilitadasBool = notificacoesHabilitadasSwitchValue as! Bool
            configurationTO.notificacoesHabilitadas = String(notificacoesHabilitadasBool)
        }
        if let notifBitcoinVendaSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinVendaSwitch") {
            let notifBitcoinVendaBool = notifBitcoinVendaSwitchValue as! Bool
            configurationTO.notificarBitcoinVenda = String(notifBitcoinVendaBool)
        }
        if let notifBitcoinCompraSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinCompraSwitch") {
            let notifBitcoinCompraBool = notifBitcoinCompraSwitchValue as! Bool
             configurationTO.notificarBitcoinCompra = String(notifBitcoinCompraBool)
        }
        if let notifBitcoinCashVendaSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinCashVendaSwitch") {
            let notifBitcoinCashVendaBool = notifBitcoinCashVendaSwitchValue as! Bool
            configurationTO.notificarBitcoinCashVenda = String(notifBitcoinCashVendaBool)
        }
        if let notifBitcoinCashCompraSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinCashCompraSwitch") {
            let notifBitcoinCashCompraBool = notifBitcoinCashCompraSwitchValue as! Bool
            configurationTO.notificarBitcoinCashCompra = String(notifBitcoinCashCompraBool)
        }
        if let notifLitecoinVendaSwitchValue = UserDefaults.standard.object(forKey: "notifLitecoinVendaSwitch") {
            let notifLitecoinVendaBool = notifLitecoinVendaSwitchValue as! Bool
            configurationTO.notificarLiteCoinVenda = String(notifLitecoinVendaBool)
        }
        if let notifLitecoinCompraSwitchValue = UserDefaults.standard.object(forKey: "notifLitecoinCompraSwitch") {
            let notifLitecoinCompraBool = notifLitecoinCompraSwitchValue as! Bool
            configurationTO.notificarLiteCoinCompra = String(notifLitecoinCompraBool)
        }
        if let tokenValue = UserDefaults.standard.object(forKey: "token") {
            let token = tokenValue as! String
            configurationTO.token = token
        }
        
         service.salvarConfiguracoes(configurationTO: configurationTO)
    }
    
    @IBAction func definirValoresAtuais(_ sender: Any) {
        if  let object = UserDefaults.standard.object(forKey: "bitCoinObject")  {
            let bitCoinObject = object as! [String: Any]
            let bitCoinBase = util.definirValorAtual(objetoJson: bitCoinObject, moeda: "bitCoinBase")
            if bitCoinBase != "" {
                bitCoinBaseLabel.text = bitCoinBase
            }
        }
        
        if  let object = UserDefaults.standard.object(forKey: "bitCoinCashObject")  {
            let bitCoinCashObject = object as! [String: Any]
            let bitCoinCashBase = util.definirValorAtual(objetoJson: bitCoinCashObject, moeda: "bitCoinCashBase")
            if bitCoinCashBase != "" {
                bitCoinCashBaseLabel.text = bitCoinCashBase
            }
        }
        
        if  let object = UserDefaults.standard.object(forKey: "liteCoinObject")  {
            let liteCoinObject = object as! [String: Any]
            let liteCoinBase = util.definirValorAtual(objetoJson: liteCoinObject, moeda: "liteCoinBase")
            if liteCoinBase != "" {
                liteCoinBaseLabel.text = liteCoinBase
            }
        }
        
    }
    
    @IBAction func definirValoresAuto(_ sender: Any) {
        
        if  let object = UserDefaults.standard.object(forKey: "bitCoinObject")  {
            let bitCoinObject = object as! [String: Any]
            let bitCoinBase = util.definirValorMedio(objetoJson: bitCoinObject, moeda: "bitCoinBase")
            if bitCoinBase != "" {
                bitCoinBaseLabel.text = bitCoinBase
            }
        }
        
        if  let object = UserDefaults.standard.object(forKey: "bitCoinCashObject")  {
            let bitCoinCashObject = object as! [String: Any]
            let bitCoinCashBase = util.definirValorMedio(objetoJson: bitCoinCashObject, moeda: "bitCoinCashBase")
            if bitCoinCashBase != "" {
                bitCoinCashBaseLabel.text = bitCoinCashBase
            }
        }
        
        if  let object = UserDefaults.standard.object(forKey: "liteCoinObject")  {
            let liteCoinObject = object as! [String: Any]
            let liteCoinBase = util.definirValorMedio(objetoJson: liteCoinObject, moeda: "liteCoinBase")
            if liteCoinBase != "" {
                liteCoinBaseLabel.text = liteCoinBase
            }
        }
        
    }
    
    @IBAction func definirIntervalo(_ sender: Any) {
        if intervaloText.text != nil && intervaloText.text != "" {
            let valor:String = intervaloText.text!
            let valorInt = Int(valor)
            UserDefaults.standard.set(valorInt, forKey: "intervalo")
            intervaloLabel.text = valor
        }
        intervaloText.text = ""
    }
    
    @IBAction func definirMargem(_ sender: Any) {
        if margemText.text != nil && margemText.text != "" {
            let valor:String = margemText.text!
            let valorDouble = Double(valor)
            UserDefaults.standard.set(valorDouble, forKey: "margem")
            margemLabel.text = valor + "%"
        }
        margemText.text = ""
    }
    
    @IBAction func atualizarBitCoinBase(_ sender: Any) {
        if bitCoinBaseText.text != nil && bitCoinBaseText.text != "" {
            let valor:String = bitCoinBaseText.text!
            let valorDouble = Double(valor)
            UserDefaults.standard.set(valorDouble, forKey: "bitCoinBase")
            bitCoinBaseLabel.text = util.formatarPreco(preco: NSNumber(value: valorDouble!))
        }
        bitCoinBaseText.text = ""
    }
    
    @IBAction func atualizarBitCoinCashBase(_ sender: Any) {
        if bitCoinCashBaseText.text != nil && bitCoinCashBaseText.text != "" {
            let valor:String = bitCoinCashBaseText.text!
            let valorDouble = Double(valor)
            UserDefaults.standard.set(valorDouble, forKey: "bitCoinCashBase")
            bitCoinCashBaseLabel.text = util.formatarPreco(preco: NSNumber(value: valorDouble!))
        }
        bitCoinCashBaseText.text = ""
    }
    
    @IBAction func atualizarLiteCoinBase(_ sender: Any) {
        if liteCoinBaseText.text != nil && liteCoinBaseText.text != "" {
            let valor:String = liteCoinBaseText.text!
            let valorDouble = Double(valor)
            UserDefaults.standard.set(valorDouble, forKey: "liteCoinBase")
            liteCoinBaseLabel.text = util.formatarPreco(preco: NSNumber(value: valorDouble!))
        }
        liteCoinBaseText.text = ""
    }
    
    
    fileprivate func carregarValoresReferencia() {
        if let bitCoinBase  = UserDefaults.standard.object(forKey: "bitCoinBase") {
            bitCoinBaseLabel.text = util.formatarPreco(preco: NSNumber(value: bitCoinBase as! Double))
        }
        if  let bitCoinCashBase = UserDefaults.standard.object(forKey: "bitCoinCashBase") {
            bitCoinCashBaseLabel.text = util.formatarPreco(preco: NSNumber(value: bitCoinCashBase as! Double))
            
        }
        if let liteCoinBase = UserDefaults.standard.object(forKey: "liteCoinBase") {
            liteCoinBaseLabel.text = util.formatarPreco(preco: NSNumber(value: liteCoinBase as! Double))
        }
        
        if let margem = UserDefaults.standard.object(forKey: "margem") {
            margemLabel.text = String(describing: margem) + "%"
        }
        
        if let intervalo = UserDefaults.standard.object(forKey: "intervalo") {
            intervaloLabel.text = String(describing: intervalo)
        }
        
        if let notifBitcoinVendaSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinVendaSwitch") {
            notifBitcoinVendaSwitch.isOn = notifBitcoinVendaSwitchValue as! Bool
        }
        if let notifBitcoinCompraSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinCompraSwitch") {
            notifBitcoinCompraSwitch.isOn = notifBitcoinCompraSwitchValue as! Bool
        }
        
        if let notifBitcoinCashVendaSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinCashVendaSwitch") {
            notifBitcoinCashVendaSwitch.isOn = notifBitcoinCashVendaSwitchValue as! Bool
        }
        if let notifBitcoinCashCompraSwitchValue = UserDefaults.standard.object(forKey: "notifBitcoinCashCompraSwitch") {
            notifBitcoinCashCompraSwitch.isOn = notifBitcoinCashCompraSwitchValue as! Bool
        }
        
        if let notifLitecoinVendaSwitchValue = UserDefaults.standard.object(forKey: "notifLitecoinVendaSwitch") {
            notifLitecoinVendaSwitch.isOn = notifLitecoinVendaSwitchValue as! Bool
        }
        if let notifLitecoinCompraSwitchValue = UserDefaults.standard.object(forKey: "notifLitecoinCompraSwitch") {
            notifLitecoinCompraSwitch.isOn = notifLitecoinCompraSwitchValue as! Bool
        }
        if let notificacoesHabilitadasSwitchValue = UserDefaults.standard.object(forKey: "notificacoesHabilitadasSwitch") {
            notificacoesHabilitadasSwitch.isOn = notificacoesHabilitadasSwitchValue as! Bool
        }
    }
    
    //Esconder teclado ao clicar fora
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

}
