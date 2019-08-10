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



class MainView : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var pages: NSArray = ["Bank", "PlayerInfo", "Ads", "Broadcast", "Experiment"];
    var pagecount: Int = 5;
    var index: Int = 2;
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        self.setViewControllers([getViewControllerAtIndex(index)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func getViewControllerAtIndex(_ index: NSInteger) -> UIViewController!
    {
        if index == 0
        {
             return self.storyboard?.instantiateViewController(withIdentifier: "BankView") as! BankView;
        }
        
        if index == 1
        {
            return self.storyboard?.instantiateViewController(withIdentifier: "PlayerInfoView") as! PlayerInfoView;
        }
        
        if index == 2
        {
            return self.storyboard?.instantiateViewController(withIdentifier: "AdView") as! AdView;
        }
        
        if index == 3
        {
            return self.storyboard?.instantiateViewController(withIdentifier: "BroadcastView") as! BroadcastView;
        }
        
        if index == 4
        {
            return self.storyboard?.instantiateViewController(withIdentifier: "ExperimentView") as! ExperimentView;
        }
        

        return nil;
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        //let id = NSStringFromClass(viewController.classForCoder)
        //let index = self.pages.index(of: id)
        
        if (index > 0)
        {
            index = index - 1
        }
        else
        {
            index = pagecount - 1;
        }
        
        
        return self.getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        //let id = NSStringFromClass(viewController.classForCoder)
        
        
        
        if (self.index < pagecount)
        {
            index = index + 1
        }
        else
        {
            index = 0;
        }
        return self.getViewControllerAtIndex(index)
    }
    
}
