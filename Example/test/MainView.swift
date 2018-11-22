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
    
    
    var pages: NSArray = ["Bank", "PlayerInfo", "Ads"];
    var index = 0;
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func getViewControllerAtIndex(_ index: NSInteger) -> UIViewController!
    {
        if index == 1
        {
             return self.storyboard?.instantiateViewController(withIdentifier: "BankView") as! BankView;
        }
        
        if index == 1
        {
            return self.storyboard?.instantiateViewController(withIdentifier: "PlayerInfoView") as! PlayerInfoView;
        }
        
        if index == 0
        {
            return self.storyboard?.instantiateViewController(withIdentifier: "AdView") as! AdView;
        }

        return nil;
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let id = NSStringFromClass(viewController.classForCoder)
        let index = self.pages.index(of: id)
        
        if (index == 0)
        {
            return nil;
        }
        
        self.index = self.index - 1
        return self.getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let id = NSStringFromClass(viewController.classForCoder)
        let index = self.pages.index(of: id)
        
        if (index == pages.count - 1)
        {
            return nil;
        }
        
        self.index = self.index + 1
        return self.getViewControllerAtIndex(self.index)
    }
    
}
