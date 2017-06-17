//
//  HomePageViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 15/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class HomePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: "HistoryViewController")
        let vc2 = sb.instantiateViewController(withIdentifier: "WalletViewController")
        let vc3 = sb.instantiateViewController(withIdentifier: "SendCryptoCurrencyViewController")
        return [vc1, vc2, vc3]
        
    }()
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil}
        guard  viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y>0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataSource = self
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
