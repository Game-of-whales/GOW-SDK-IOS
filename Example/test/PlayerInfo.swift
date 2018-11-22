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

import Foundation
import GameOfWhales


class PlayerInfo
{
    static var sharedInstance: PlayerInfo = PlayerInfo()
    
    var userClass:String = "Warrior";
    var level:Int = 1;
    var coins:Int = 100000;
    var location:String = "A";
    var locationCode:Int = 0;
    var gender:Bool = false;
    var productCoins:[String:Int] = ["product_5":500, "product_10":1000, "product_20":2500, "sub_week_grace3_1":0, "sub_month_graceno_2":0]
    
    public func getItemCost(itemID:String) -> Int
    {
        if (itemID == "item1")
        {
            return 1000;
        }
        
        if (itemID == "item2")
        {
            return 2000;
        }
        
        return 1;
    }
    
    
    public func getLevel() -> Int
    {
        return level
    }
    
    public func getLocation() -> String
    {
        return location
    }
    
    public func getGender() -> Bool
    {
        return gender
    }
    
    public func getUserClass() -> String
    {
        return userClass
    }
    
    public func getProductCoins(productIdentifier:String)->Int{
        return productCoins[productIdentifier]!;
    }
    
    func load()
    {
        let defaults = UserDefaults.standard
        
        locationCode = defaults.integer(forKey: "location") == 0 ? locationCode : defaults.integer(forKey: "location")
        level = defaults.integer(forKey: "level") == 0 ? level : defaults.integer(forKey: "level")
        userClass = defaults.string(forKey: "class") == nil ? userClass : defaults.string(forKey: "class")!
        gender = defaults.bool(forKey: "gender")
        coins = defaults.integer(forKey: "coins") == 0 ? coins : defaults.integer(forKey: "coins")
    }
    
    func save()
    {
        let defaults = UserDefaults.standard
        
        defaults.set(level, forKey: "level")
        defaults.set(userClass, forKey: "class")
        defaults.set(gender, forKey: "gender")
        defaults.set(locationCode, forKey: "location")
        defaults.set(coins, forKey: "coins");
    }
    
    init()
    {
        var classes: [String] = ["Warrior", "Wizard", "Rogue"]
        
        userClass = classes[Int(arc4random() % 3)]
        
        gender = arc4random() % 2 == 0 ? false : true;
        
        load()
        
        updateLocation()
    }
    
    
    public func addLevel()
    {
        level += 1;
        GW.profile(["level":level])
        save()
    }
    
    public func incCoins(val:Int){
        coins += val;
        GW.profile(["coins":coins]);
        save();
    }
    
    public func getCoins() -> Int {
        return coins;
    }
    
    public func decCoins(val:Int) {
        coins -= val
        GW.profile(["coins":coins]);
        save();
    }
    
    public func canBuy(cost:Int) -> Bool {
        return cost <= coins;
    }
    
    func updateLocation()
    {
        let startingValue = Int(("A" as UnicodeScalar).value)
        location = String(Character(UnicodeScalar(startingValue + locationCode)!))
    }
    
    public func nextLocation()
    {
        locationCode += 1;
        if (locationCode >= 33)
        {
            locationCode = 0;
        }
        
        GW.profile(["location_\(locationCode)":true])
        
        updateLocation()
        save()
    }
}
