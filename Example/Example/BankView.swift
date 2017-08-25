//
//  BankView.swift
//  test
//
//  Created by Denis Sachkov on 21.06.17.
//  Copyright © 2017 GameOfWhales. All rights reserved.
//

import UIKit
import GameOfWhales



class BankView : UIViewController, SKProductsRequestDelegate, GWDelegate, SKPaymentTransactionObserver
{
    
    var products: Dictionary<String, SKProduct> = Dictionary();
    
    @IBOutlet var product5Button:UIButton!
    @IBOutlet var product10Button:UIButton!
    @IBOutlet var product20Button:UIButton!
    @IBOutlet var messageText:UILabel!
    
    var timer = Timer();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        //read product information
        let req = SKProductsRequest(productIdentifiers: ["product_5", "product_10", "product_20"]);
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
    }
   
    func onTimerUpdate()
    {
        updateButtons();
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
        GW.shared().add(self);
        SKPaymentQueue.default().add(self);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove self from delegates
        GW.shared().remove(self)
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
    
    func specialOffersUpdated() {
        NSLog("Special offer updated");
    }
    
    func onPushDelivered(_ camp: String, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
        alert.addAction(ok)
        present(alert, animated: true, completion: {
            GW.shared().reactedRemoteNotification(withCampaign: camp);
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
        
        let offer = GW.shared().getSpecialOffer(productIdentifier);
        
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
        }
        
        button.setTitle(title, for: UIControlState.normal);
        button.setNeedsDisplay();
    }
    
    private func buy(productIdentifier:String)->Void{
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
                GW.shared().purchaseTransaction(t, product: product!);
                GW.shared().converting(["coins":coins as NSNumber, t.payment.productIdentifier:-1], place: "bank")
                NotificationCenter.default.post(name: .onViewNeedUpdate, object: nil);
                
                SKPaymentQueue.default().finishTransaction(t)
                
            }
        }
    }
}
