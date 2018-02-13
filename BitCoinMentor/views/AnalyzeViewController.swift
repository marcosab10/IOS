//
//  AnalyzeViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 12/02/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class AnalyzeViewController: UIViewController {
    
    var analyze: NSManagedObject?
    
    @IBOutlet weak var tempoEmMinutosText: UITextField!
    @IBOutlet weak var margemText: UITextField!
    @IBOutlet weak var notificacoesAtivasSwitch: UISwitch!
    @IBOutlet weak var notificacaoPositivaSwitch: UISwitch!
    @IBOutlet weak var notificacaoNegativaSwitch: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
     
        carregarValores()
        

    }
    
    
    @IBAction func salvar(_ sender: Any) {
        
        
        
    }
    
    fileprivate func carregarValores() {
        if analyze != nil
        {
            tempoEmMinutosText.text = String(describing: analyze?.value(forKey: "timeMinutes") as! Int64)
            margemText.text = analyze?.value(forKey: "margin") as? String
            
            if let activeNotification = analyze?.value(forKey: "activeNotification") as? String {
                if activeNotification == "true" {
                    notificacoesAtivasSwitch.isOn = true
                }
                else{
                    notificacoesAtivasSwitch.isOn = false
                }
            }
            
            if let notifyPositive = analyze?.value(forKey: "notifyPositive") as? String {
                if notifyPositive == "true" {
                    notificacaoPositivaSwitch.isOn = true
                }
                else{
                    notificacaoPositivaSwitch.isOn = false
                }
            }
            
            if let notifyNegative = analyze?.value(forKey: "notifyNegative") as? String {
                if notifyNegative == "true" {
                    notificacaoNegativaSwitch.isOn = true
                }
                else{
                    notificacaoNegativaSwitch.isOn = false
                }
            }
        }
    }
    
    //Esconder teclado ao clicar fora
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
