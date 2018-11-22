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



class BankView : UIViewController, SKProductsRequestDelegate, GWDelegate, SKPaymentTransactionObserver
{
    
    var products: Dictionary<String, SKProduct> = Dictionary();
    
    @IBOutlet var product5Button:UIButton!
    @IBOutlet var product10Button:UIButton!
    @IBOutlet var product20Button:UIButton!
    @IBOutlet var sub1Button:UIButton!
    @IBOutlet var sub2Button:UIButton!
    @IBOutlet var messageText:UILabel!
    @IBOutlet var messageText2:UILabel!;
    @IBOutlet var serverTimeLabel:UILabel!;
    
    var timer = Timer();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        //read product information
        let req = SKProductsRequest(productIdentifiers: ["product_5", "product_10", "product_20", "sub_week_grace3_1", "sub_month_graceno_2"]);
        
        req.delegate = self;
        req.start();
        
        scheduledTimerWithTimeInterval();
        updateButtons();
        
        messageText.text = "";
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func updateButtons()
    {
        updateButton(button: product5Button!, productIdentifier: "product_5");
        updateButton(button: product10Button!, productIdentifier: "product_10");
        updateButton(button: product20Button!, productIdentifier: "product_20");
        updateButton(button: sub1Button!, productIdentifier: "sub_week_grace3_1");
        updateButton(button: sub2Button!, productIdentifier: "sub_month_graceno_2");
    }
   
    func onTimerUpdate()
    {
        updateButtons();
        
        let st = GW.getServerTime()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        let strDate = dateFormatter.string(from: st!)
        serverTimeLabel.text = strDate;
        
        /*let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss";
        let date = GW.
        let calendar = Calendar.current;
        let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: offer!.finishedAt);
        let diffDate = calendar.date(from: components)
        let strDate = dateFormatter.string(from: diffDate!);
        title = title + "\nTime left: \(strDate)";*/
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        for p in response.products {
            products[p.productIdentifier] = p
        }
        
       updateButtons()
    }
    
    func OnRemoteNotificationReceived(notification:[AnyHashable : Any]){
        loadViewIfNeeded()
        
        let aps = notification["aps" as NSString] as? [String:AnyObject]
        let alert = aps?["alert"] as? [String:AnyObject]
        let title = alert?["title"] as? String
        let body = alert?["body"] as? String
        let text = "\(title ?? ""):\(body ?? "")"
        
        self.messageText.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GW.add(self);
        SKPaymentQueue.default().add(self);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove self from delegates
        GW.remove(self)
        SKPaymentQueue.default().remove(self);
    }
    
    @IBAction func product5ButtonAction(sender: UIButton) {
        buy(productIdentifier: "product_5")
    }
    
    @IBAction func product10ButtonAction(sender: UIButton) {
        buy(productIdentifier: "product_10")
    }
    
    @IBAction func product20ButtonAction(sender: UIButton) {
        buy(productIdentifier: "product_20")
    }
    
    @IBAction func sub1ButtonAction(sender: UIButton) {
        buy(productIdentifier: "sub_week_grace3_1")
    }
    
    @IBAction func sub2ButtonAction(sender: UIButton) {
        buy(productIdentifier: "sub_month_graceno_2")
    }
    
    func specialOffersUpdated() {
        NSLog("Special offer updated");
    }
    
    func onPushDelivered(_ offer:GWSpecialOffer?, camp: String, title:String, message:String) {
        if (offer != nil)
        {
            NSLog("OnPushDelivered: %@", offer!.campaign);
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
        alert.addAction(ok)
        present(alert, animated: true, completion: {
            GW.reactedRemoteNotification(withCampaign: camp);
        })
    }
    
    func specialOfferDisappeared(_ specialOffer: GWSpecialOffer) {
        let productIdentifier = specialOffer.product;
        
        NSLog("BankView: Special offer disappeared for %@", productIdentifier);
        updateButtons()
    }
    
    func specialOfferAppeared(_ specialOffer: GWSpecialOffer) {
        let productIdentifier = specialOffer.product;
        
        NSLog("BankView: Special offer appeared for %@", productIdentifier);
        updateButtons()
    }
    
    func futureSpecialOfferAppeared(_ specialOffer: GWSpecialOffer) {
        let productIdentifier = specialOffer.product;
        NSLog("BankView: Special offer appeared for %@", productIdentifier);
    }
    
    func onAdClosed() {
        
    }
    
    func onAdLoaded() {
    }
    
    func onAdLoadFailed() {
        
    }
    
    func onPurchaseVerified(_ transactionID: String, state: String) {
        NSLog("Purchase verify state: %@", state);
    }
    
    private func updateButton(button:UIButton, productIdentifier:String) -> Void{
        
        var title = productIdentifier;
        let coins = PlayerInfo.sharedInstance.getProductCoins(productIdentifier: productIdentifier);
        
        let p = products[productIdentifier];
        if (p != nil)
        {
            title = p!.localizedTitle + " for \(p!.price)";
        }
        
        let offer = GW.getSpecialOffer(productIdentifier);
        
        if (offer != nil && (offer?.hasCountFactor())!)
        {
            title = title + "\nSpecial Offer!";
        }
        
        title = title + "\nCoins: \(coins)";
        
        
        
         if (offer != nil && (offer?.hasCountFactor())!)
        {
            let countFactor = offer!.countFactor;
            let bonusCoins = Int(Float(coins) * countFactor) - coins;
            let percent = Int((countFactor - 1.0) * 100.0);
            title = title + " + \(bonusCoins) ( \(percent)% Bonus!)";
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss";
            //let date =
            let date = Date();
            let calendar = Calendar.current;
            let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: offer!.finishedAt);
            let diffDate = calendar.date(from: components)
            let strDate = dateFormatter.string(from: diffDate!);
            title = title + "\nTime left: \(strDate)";
            
            dump(offer?.customValues);
        }
        
        button.setTitle(title, for: UIControlState.normal);
        button.setNeedsDisplay();
    }
    
    private func buy(productIdentifier:String)->Void{
        //messageText2.text = "";
        /*var z = 5;
        var x = 6;
        var y = 5;
        x = y / ( z / x);*/
        
        let p = products[productIdentifier];
        //let so = GW.shared().specialOffer(for: productIdentifier);
        let payment = SKMutablePayment(product: p!)
        payment.simulatesAskToBuyInSandbox = true
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        NSLog("updatedTransactions");
        for t in transactions
        {
            NSLog("updatedTransactions \(t.transactionState.rawValue) \(SKPaymentTransactionState.purchased.rawValue) \(SKPaymentTransactionState.failed.rawValue)");
            
            if t.transactionState == SKPaymentTransactionState.failed {
                NSLog("Error \(t.error!)")
            }
            if t.transactionState == SKPaymentTransactionState.purchased {
                let coins = PlayerInfo.sharedInstance.getProductCoins(productIdentifier: t.payment.productIdentifier);
                PlayerInfo.sharedInstance.incCoins(val: coins);
                
                let product = products[t.payment.productIdentifier]
                if (product != nil)
                {
                    GW.purchaseTransaction(t, product: product!);
                    GW.converting(["coins":coins as NSNumber, t.payment.productIdentifier:-1], place: "bank")
                    NotificationCenter.default.post(name: .onViewNeedUpdate, object: nil);
                }
               
                SKPaymentQueue.default().finishTransaction(t)
            }
        }
    }
}
