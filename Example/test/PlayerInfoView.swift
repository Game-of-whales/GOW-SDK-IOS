/*
 * Game Of Whales SDK
 *
 * https://www.gameofwhales.com/
 *
 * Copyright © 2018 GameOfWhales. All rights reserved.
 *
 * Licence: https://www.gameofwhales.com/licence
 *
 */

import UIKit
import GameOfWhales


extension Notification.Name {
    static let onViewNeedUpdate = Notification.Name("gow-on-view-need-update");
}


class PlayerInfoView : UIViewController
{
    @IBOutlet var addLevelButton:UIButton!
    @IBOutlet var nextLocationButton:UIButton!
    @IBOutlet var classText:UILabel!
    @IBOutlet var genderText:UILabel!
    @IBOutlet var coinsText:UILabel!
    
    @IBOutlet var buyItem1Button:UIButton!
    @IBOutlet var buyItem2Button:UIButton!
    
    var timer = Timer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
         updateViewParameters()
        
                NotificationCenter.default.addObserver(self, selector: #selector(self.updateViews), name: .onViewNeedUpdate, object: nil);
        
        scheduledTimerWithTimeInterval();
    }
    
    func updateViewParameters()
    {
        classText.text = "Class: " + PlayerInfo.sharedInstance.getUserClass()
        genderText.text = PlayerInfo.sharedInstance.getGender() ? "Gender: Man" : "Gender: Woman"
        coinsText.text = "Coins: " + String(PlayerInfo.sharedInstance.getCoins());
        
        addLevelButton.setTitle("LEVEL UP ( " + String(PlayerInfo.sharedInstance.getLevel()) + " )", for: .normal)
        nextLocationButton.setTitle("NEXT LOCATION ( " + PlayerInfo.sharedInstance.getLocation() + " )", for: .normal)
    }
    
   
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func onTimerUpdate()
    {
        updateButtons();
    }

    func updateButtons()
    {
        updateButton(button: buyItem1Button, item: "item1");
        updateButton(button: buyItem2Button, item: "item2");
    }
    
    func updateButton(button: UIButton, item:String)
    {
        var text = item;
        
        let offer = GW.getSpecialOffer(item);
        
        var cost = PlayerInfo.sharedInstance.getItemCost(itemID: item);
        
        let useoffer = offer != nil && (offer?.hasPriceFactor())!;
        
        
        if (useoffer)
        {
            cost = Int(Float(cost) * offer!.priceFactor);
        }
        
        text = text + " Cost: \(cost)";
        
        
        if (useoffer)
        {
            let percent = Int(100.0 - offer!.priceFactor * 100.0);
            text = text + " ( \(percent)% Discount! )";
        }
        
        if (useoffer)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss";
            //let date =
            let date = Date();
            let calendar = Calendar.current;
            let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: offer!.finishedAt);
            let diffDate = calendar.date(from: components)
            let strDate = dateFormatter.string(from: diffDate!);
            text = text + "\nTime left: \(strDate)";
        }
        
        button.setTitle(text, for: UIControlState.normal);
        button.setNeedsDisplay();
    }

    //Parameters
    @IBAction func addLevel(sender: UIButton) {
        
        PlayerInfo.sharedInstance.addLevel();
        updateViewParameters();
    }
    
    //Parameters
    @IBAction func nextLocation(sender: UIButton) {
        PlayerInfo.sharedInstance.nextLocation();
        updateViewParameters();
    }
    
    func updateViews(notification: NSNotification)
    {
         updateViewParameters()
    }
    
    func buy(id: String)
    {
        var cost = PlayerInfo.sharedInstance.getItemCost(itemID: id);
        
        let offer = GW.getSpecialOffer(id);
        
        if (offer != nil){
            cost = Int( Float(cost) * offer!.priceFactor);
        }
        
        if (PlayerInfo.sharedInstance.canBuy(cost: cost))
        {
            PlayerInfo.sharedInstance.decCoins(val: cost);
            GW.converting(["coins" : -cost as NSNumber, id: 1], place: "shop");
            updateViewParameters();
        }
    }
    
    @IBAction func buyItem1(sender: UIButton)
    {
        buy(id: "item1");
    }
    
    @IBAction func buyItem2(sender: UIButton)
    {
        buy(id: "item2");
    }
}


