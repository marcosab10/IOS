//
//  InicioViewController.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 15/04/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController {
    let util = Util()

    @IBOutlet weak var mainImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        util.bordasImagem(image: mainImage)
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
