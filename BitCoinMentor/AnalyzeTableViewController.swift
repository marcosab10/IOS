//
//  AnalyzeTableViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 24/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit
import CoreData

class AnalyzeTableViewController: UITableViewController {
    var util = Util()
    var analyzes: [NSManagedObject] = []
    var service: BitCoinMentorService = BitCoinMentorService()

    override func viewDidLoad() {
        super.viewDidLoad()

        service.loadAnalyzes()
        
        analyzes = service.listarAnalyzes()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return analyzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let analyze = self.analyzes[indexPath.row]
        let timeMinutes = analyze.value(forKey: "timeMinutes")
        let percentage = analyze.value(forKey: "percentage")
        
        let timeMinutesText = timeMinutes as! String
        let percentageText = percentage as! String
        
        celula.textLabel?.text =  timeMinutesText + " Minutos"
        celula.detailTextLabel?.text =  percentageText + " %"
        
         let percentageNumber = Double(percentageText)
        
        if(percentageNumber! < 0.0){
            celula.detailTextLabel?.textColor = UIColor.red
        }
        else{
             celula.detailTextLabel?.textColor = UIColor.green
        }
        
        return celula
    }
 

    
    override func viewDidAppear(_ animated: Bool) {
        let intervaloRefresh:Double = 5.0

        service.loadAnalyzes()
        analyzes = service.listarAnalyzes()
        self.tableView.reloadData()
        
        Timer.scheduledTimer(withTimeInterval: intervaloRefresh, repeats: true) { (time) in
            self.service.loadAnalyzes()
            self.analyzes = self.service.listarAnalyzes()
            self.tableView.reloadData()
        }
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
