

import Foundation
import UIKit


class BroadcastView : UIViewController
{
    @IBOutlet var BRInitReqiest:UIButton!;
    @IBOutlet var BRUserStatusReqest:UIButton!;
    @IBOutlet var BRShowAdRequest:UIButton!;
    @IBOutlet var responseText:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: NSNotification.Name(rawValue: "com.gameofwhales.action.Response"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NotificationCenter.default.removeObserver(receiveNotification(notification: ))
    }
    
    
    @IBAction func BRInitReqiestClicked(sender: UIButton) {
        let requestData:[String: String] = ["gow_type": "com.gameofwhales.initstatus.request"];
        NSLog("Broadcast BRInitReqiestClicked");
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.gameofwhales.action.Message"), object: nil, userInfo: requestData)
    }
    
    @IBAction func BRUserStatusReqestClicked(sender: UIButton) {
        let requestData:[String: String] = ["gow_type": "com.gameofwhales.userstatus.request"];
        NSLog("Broadcast BRUserStatusReqestClicked");
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.gameofwhales.action.Message"), object: nil, userInfo: requestData)
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    @IBAction func BRShowAdRequestClicked(sender: UIButton) {
        
        let price = 2.0;
        var type = "predicted";
        if randomInt(min:0, max:1000) % 2 == 0
        {
            type = "programmatic";
        }
        
        var adUnityType = "banner";
        if randomInt(min:0, max:1000) % 3 == 0
        {
            adUnityType = "interstitial";
        }
        
        if randomInt(min:0, max:1000) % 3 == 0
        {
            adUnityType = "video";
        }
        
        if randomInt(min:0, max:1000) % 4 == 0
        {
            adUnityType = "rewarded";
        }
        
        if randomInt(min:0, max:1000) % 4 == 0
        {
            adUnityType = "incentivized";
        }
        
        let requestData:[String: Any] = ["gow_type": "com.gameofwhales.ad.show.request",
                                            "price": price,
                                            "type": type,
                                            "adUnityType": adUnityType];
        
        NSLog("Broadcast BRUserStatusReqestClicked");
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.gameofwhales.action.Message"), object: nil, userInfo: requestData)
        
    }
    
    @objc public func receiveNotification(notification: Notification)
    {
        NSLog("Broadcast Response Notification: " + notification.name.rawValue);
        
        let userInfo = notification.userInfo;
        var responseString = "";
        
        for (key,value) in userInfo!{
            responseString = responseString + "\n" + "\(key) : \(value)";
        }
        DispatchQueue.main.async {
            self.responseText.text = responseString;
        }
        
        if let type = notification.userInfo?["gow_type"] as? String {
            NSLog("Broadcast Notification type: " + type);
        }
    }
}
