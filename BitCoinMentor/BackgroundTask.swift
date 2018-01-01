//
//  BackgroundTask.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 31/12/17.
//  Copyright © 2017 Marcos Faria. All rights reserved.
//

import UIKit

var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

class BackgroundTask {
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask{[weak self ] in
            
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
}
