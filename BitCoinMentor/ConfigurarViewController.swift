//
//  ConfigurarViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/12/17.
//  Copyright © 2017 Marcos Faria. All rights reserved.
//

import UIKit

class ConfigurarViewController: UIViewController {
    
    let util = Util()

    @IBOutlet weak var bitCoinBaseLabel: UILabel!
    @IBOutlet weak var bitCoinCashBaseLabel: UILabel!
    @IBOutlet weak var liteCoinBaseLabel: UILabel!
    @IBOutlet weak var margemLabel: UILabel!
    
    @IBOutlet weak var bitCoinBaseText: UITextField!
    @IBOutlet weak var bitCoinCashBaseText: UITextField!
    @IBOutlet weak var liteCoinBaseText: UITextField!
    @IBOutlet weak var margemText: UITextField!
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carregarValoresReferencia()
    }
    
    //Esconder teclado ao clicar fora
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

}
