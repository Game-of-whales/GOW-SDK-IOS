//
//  AdView.swift
//  test
//
//  Created by Denis Sachkov on 08.11.18.
//  Copyright © 2018 GameOfWhales. All rights reserved.
//

import UIKit
import GameOfWhales

class AdView : UIViewController, GWDelegate
{
    func canStart(_ experiment: GWExperiment) -> Bool {
        return false;
    }
    
    func onExperimentEnded(_ experiment: GWExperiment) {
        
    }
    
   
    
    @IBOutlet var adstate:UILabel!
    @IBOutlet var foparTitle:UILabel!
    @IBOutlet var adload:UIButton!
    @IBOutlet var adshow:UIButton!
    @IBOutlet var fo_par_toggle:UIButton!
    
    @IBOutlet var futureOffersList:UILabel!
    
    var isFOShowing:Bool = true;
    var foList:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GW.add(self);
        isFOShowing = true;
        foList = ""
        futureOffersList.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        GW.remove(self)
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        //remove self from delegates
    }
    
    @IBAction func LoadAd()
    {
        adstate.text = "ad loading"
        GW.loadAd()
    }
    
    func UpdateFOPar()
    {
        if (isFOShowing)
        {
            foparTitle.text = "Future offers:"
            futureOffersList.text = foList
        }
        else
        {
            do
            {
                foparTitle.text = "Parameters:"
                let params = GW.getProperties()
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                let strdata = String(data: jsonData, encoding: String.Encoding.utf8) as String!
                //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                futureOffersList.text = strdata
            }
            catch {
                 futureOffersList.text = "Something wrong! And ErroR!"
            }
            
        }
    }
    
    @IBAction func ShowAd()
    {
        if (GW.isAdLoaded())
        {
            adstate.text = "ad showing"
            GW.showAd()
        }
        else
        {
            adstate.text = "nothing to show, loading"
            GW.loadAd()
        }
        
    }
    
    @IBAction func ToggleFOPar()
    {
        isFOShowing = !isFOShowing
        UpdateFOPar()
    }
    
    func specialOfferAppeared(_ specialOffer: GWSpecialOffer) {
        
    }
    
    func specialOfferDisappeared(_ specialOffer: GWSpecialOffer) {
        
    }
    
    func onInitialized() {
        NSLog("SDK INITIALIZED");
    }
    
    func futureSpecialOfferAppeared(_ specialOffer: GWSpecialOffer) {
        //let productIdentifier = specialOffer.product;
        //NSLog("BankView: Special offer appeared for %@", productIdentifier);
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        let strDate = dateFormatter.string(from: specialOffer.activatedAt)
        let t = futureOffersList.text! + "\n " + specialOffer.product + ": will activated at " + strDate
        foList = foList + t;
        UpdateFOPar()
        
    }
    
    func onPushDelivered(_ specialOffer: GWSpecialOffer?, camp: String, title: String, message: String) {
        
    }
    
    func onPurchaseVerified(_ transactionID: String, state: String) {
        
    }
    
    func onAdLoaded() {
        adstate.text = "ad LOADED"
    }
    
    func onAdLoadFailed() {
        adstate.text = "ad load FAILED"
    }
    
    func onAdClosed() {
        adstate.text = "ad CLOSED"
    }
}
