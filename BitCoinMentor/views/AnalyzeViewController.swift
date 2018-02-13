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
    let service: BitCoinMentorService = BitCoinMentorService()
    let bitCoinCoreData: BitCoinCoreData = BitCoinCoreData()
    var analyzeTO: AnalyzeTO?
    
    @IBOutlet weak var tempoEmMinutosText: UITextField!
    @IBOutlet weak var margemText: UITextField!
    @IBOutlet weak var notificacoesAtivasSwitch: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
     
        carregarValores()
        
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        
        
        
    }
    
    fileprivate func carregarValores() {
        if analyzeTO != nil
        {
            let timeMinutesTemp:NSNumber = (analyzeTO?.timeMinutes)!
            
            tempoEmMinutosText.text = String(describing: timeMinutesTemp)
            margemText.text = analyzeTO?.margin
            
            notificacoesAtivasSwitch.isOn = Bool((analyzeTO?.activeNotification!)!)!
            
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
