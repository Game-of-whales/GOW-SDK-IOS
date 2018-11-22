//
//  ViewController.swift
//  test
//
//  Created by Dmitry Burlakov on 26.09.16.
//  Copyright © 2016 GameOfWhales. All rights reserved.
//

import UIKit
import GameOfWhales

class ViewController: UIViewController, SKProductsRequestDelegate, GWDelegate, SKPaymentTransactionObserver {
    var products:Dictionary<String, SKProduct> = Dictionary();
    @IBOutlet var product5Button:UIButton!
    @IBOutlet var product10Button:UIButton!
    @IBOutlet var product20Button:UIButton!
    @IBOutlet var messageText:UILabel!
    
    @IBOutlet var addLevelButton:UIButton!
    @IBOutlet var nextLocationButton:UIButton!
    @IBOutlet var classText:UILabel!
    @IBOutlet var genderText:UILabel!
    
    var parameters:ParametersAdapter = ParametersAdapter();

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewParameters()
        
        //read product information
        let req = SKProductsRequest(productIdentifiers: ["product_5", "product_10", "product_20"]);
        req.delegate = self;
        req.start();
        
        //add delegate
        GW.shared().add(self)
        
        updateButton(button: product5Button!, productIdentifier: "product_5");
        updateButton(button: product10Button!, productIdentifier: "product_10");
        updateButton(button: product20Button!, productIdentifier: "product_20");
        
        messageText.text = "";
        
        SKPaymentQueue.default().add(self);
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        for p in response.products {
            products[p.productIdentifier] = p
        }
        updateButton(button: product5Button!, productIdentifier: "product_5");
        updateButton(button: product10Button!, productIdentifier: "product_10");
        updateButton(button: product20Button!, productIdentifier: "product_20");
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

    func specialOffer(_ specialOffer: GWSpecialOffer!, appearedFor productIdentifier: String!) {
        NSLog("Special offer appeared for %@", productIdentifier);
        if(productIdentifier == "product_5"){
            updateButton(button: product5Button!, productIdentifier: "product_5")
        } else if(productIdentifier == "product_10"){
            updateButton(button: product10Button!, productIdentifier: "product_10")
        } else if(productIdentifier == "product_20"){
            updateButton(button: product20Button!, productIdentifier: "product_20")
        }
    }

    func specialOffer(_ specialOffer: GWSpecialOffer!, disappearedFor productIdentifier: String!) {
        NSLog("Special offer disappeared for %@", productIdentifier);
        if(productIdentifier == "product_5"){
            updateButton(button: product5Button!, productIdentifier: "product_5")
        } else if(productIdentifier == "product_10"){
            updateButton(button: product10Button!, productIdentifier: "product_10")
        } else if(productIdentifier == "product_20"){
            updateButton(button: product20Button!, productIdentifier: "product_20")
        }
    }

    private func updateButton(button:UIButton, productIdentifier:String) -> Void{
        let so = GW.shared().specialOffer(for: productIdentifier)
        var title = String(format: "Regular %@", productIdentifier);
        let coins = parameters.getProductCoins(productIdentifier: productIdentifier);
        let p = products[productIdentifier];
        if (p != nil){
            let price = p!.price;
            let currency = p!.priceLocale.currencyCode!;
            if (so != nil){
                title = "SO \(Int(Double(coins)/(so?.discount)!)) coins for \(currency)\(price)";
            } else {
                title = "\(coins) coins for \(currency)\(price)";
            }
        }
        NSLog("updateButton for: %@ ", title)
        button.setTitle(title, for: UIControlState.normal);
        button.setNeedsDisplay();
    }

    private func buy(productIdentifier:String)->Void{
        let p = products[productIdentifier];
        let so = GW.shared().specialOffer(for: productIdentifier);
        let payment = SKMutablePayment(product: p!)
        payment.simulatesAskToBuyInSandbox = true
        SKPaymentQueue.default().add(payment)
    }
    
    /*
     @IBOutlet var addLevelButton:UIButton!
     @IBOutlet var nextLocationButton:UIButton!
     @IBOutlet var classText:UILabel!
     @IBOutlet var genderText:UILabel!
 */

    func updateViewParameters()
    {
        classText.text = parameters.getUserClass()
        genderText.text = parameters.getGender() ? "M" : "W"
        
        addLevelButton.setTitle("LEVEL UP ( " + String(parameters.getLevel()) + " )", for: .normal)
        nextLocationButton.setTitle("NEXT LOCATION ( " + parameters.getLocation() + " )", for: .normal)
    }

    //Parameters
    @IBAction func addLevel(sender: UIButton) {

        parameters.addLevel();
        updateViewParameters();
    }
    
    //Parameters
    @IBAction func nextLocation(sender: UIButton) {
        parameters.nextLocation();
        updateViewParameters();
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
                let coins = parameters.getProductCoins(productIdentifier: t.payment.productIdentifier);
                parameters.incCoins(val: coins);
                GW.shared().purchaseTransaction(t, product: products[t.payment.productIdentifier]!);
                SKPaymentQueue.default().finishTransaction(t)

            }
        }
    }
}

