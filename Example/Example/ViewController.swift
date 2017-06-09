//
//  ViewController.swift
//  test
//
//  Created by Dmitry Burlakov on 26.09.16.
//  Copyright © 2016 GameOfWhales. All rights reserved.
//

import UIKit
import GameOfWhales

class ViewController: UIViewController, GWManagerDelegate, SKProductsRequestDelegate {
    
    var products:Dictionary<String, SKProduct> = Dictionary();
    @IBOutlet var product5Button:UIButton!
    @IBOutlet var product10Button:UIButton!
    @IBOutlet var product20Button:UIButton!
    @IBOutlet var messageText:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //read product information
        let req = SKProductsRequest(productIdentifiers: ["product_5", "product_10", "product_20"]);
        req.delegate = self;
        req.start();
        
        //add delegate
        GWManager.shared().add(self)
        
        updateButton(button: product5Button!, productIdentifier: "product_5");
        updateButton(button: product10Button!, productIdentifier: "product_10");
        updateButton(button: product20Button!, productIdentifier: "product_20");
        
        messageText.text = "";
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        for p in response.products {
            products[p.productIdentifier] = p
        }
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
        GWManager.shared().remove(self)
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
    
    //when replacement purchased
    func purchasedReplacement(_ replacement: GWReplacement, transaction: SKPaymentTransaction) {
        NSLog("Replacement %@  purchased", replacement)
        
        let message = String.init(format: "You bought %@ for %@ instead %@", replacement.originalProductIdentifier, replacement.price, replacement.originalPrice)
        
        let alert = UIAlertController(title: "Thank you for purchase", message: message, preferredStyle: UIAlertControllerStyle.alert);
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func appearedReplacement(_ replacement: GWReplacement) {
        NSLog("Replacement %@  appeared", replacement)
        if(replacement.originalProductIdentifier == "product_5"){
            updateButton(button: product5Button!, productIdentifier: "product_5")
        } else if(replacement.originalProductIdentifier == "product_10"){
            updateButton(button: product10Button!, productIdentifier: "product_10")
        } else if(replacement.originalProductIdentifier == "product_20"){
            updateButton(button: product20Button!, productIdentifier: "product_20")
        }
    }
    
    func disappearedReplacement(_ replacement: GWReplacement) {
        NSLog("Replacement %@  disappeared", replacement);
        if(replacement.originalProductIdentifier == "product_5"){
            updateButton(button: product5Button!, productIdentifier: "product_5")
        } else if(replacement.originalProductIdentifier == "product_10"){
            updateButton(button: product10Button!, productIdentifier: "product_10")
        }else if(replacement.originalProductIdentifier == "product_20"){
            updateButton(button: product20Button!, productIdentifier: "product_20")
        }
    }
    
    private func updateButton(button:UIButton, productIdentifier:String) -> Void{
        
        let rep = GWManager.shared().replacement(forProductIdentifier: productIdentifier);
        var title = String(format: "Regular %@", productIdentifier);
        if (rep != nil){
            title = String(format: "SO %@ $%@", (rep?.productIdentifier)!, (rep?.price)!);
        } else if ((products[productIdentifier]) != nil){
            let p = products[productIdentifier];
            title = String(format: "%@ $%@", p!.productIdentifier, p!.price);
        }
        NSLog("updateButton for: %@ ", title)
        button.setTitle(title, for: UIControlState.normal);
        button.setNeedsDisplay();
    }
    
    private func buy(productIdentifier:String)->Void{
        let p = products[productIdentifier];
        let rep = GWManager.shared().replacement(forProductIdentifier: productIdentifier);
        if (rep != nil){
            //buy replacement
            NSLog("Will buy %@", rep!.product.productIdentifier);
            let payment = SKMutablePayment(product: rep!.product)
            payment.simulatesAskToBuyInSandbox = true
            SKPaymentQueue.default().add(payment)
        } else {
            //buy regular product
            NSLog("Will buy %@", p!.productIdentifier);
            let payment = SKMutablePayment(product: p!)
            payment.simulatesAskToBuyInSandbox = true
            SKPaymentQueue.default().add(payment)
        }
    }
    
    
}

