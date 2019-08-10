//
//  ExperimentView.swift
//  test
//
//  Created by Denis Sachkov on 22/07/2019.
//  Copyright © 2019 GameOfWhales. All rights reserved.
//

import UIKit
import GameOfWhales

import Foundation



internal class ExperimentView : UIViewController
{
    @IBOutlet internal var experimentLabel: UILabel!
    
    var timer = Timer();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        onTimerUpdate();
        scheduledTimerWithTimeInterval();
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerUpdate()
    {
        experimentLabel.text = AppDelegate.GetExperimentString();
    }
    
}
