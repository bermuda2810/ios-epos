//
//  MyPagingViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/27/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class MyPagingViewController: UIPageViewController {

    private var pageTitles = ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5" , "Page 6"]
    private var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        initalFirstPage()
    }
    

    private func initalFirstPage() {
        let initialVC = HomeStoryBoard().getControllerByStoryboardID(identifier: "PageViewController") as! PageViewController
        initialVC.myTitle = pageTitles[0]
        self.setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        self.didMove(toParent: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyPagingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
       guard let currentVC = viewController as? PageViewController else {
                return nil
            }
            var index = currentVC.myIndex
            if index == 0 {
                return nil
            }
            index -= 1
            return loadPageController(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewController else {
                return nil
            }
            var index = currentVC.myIndex
            if (index + 1) == self.pageTitles.count {
                return nil
            }
            index += 1
            return loadPageController(index: index)
    }
    
    private func loadPageController(index : Int) -> PageViewController{
        let pageVC = HomeStoryBoard().getControllerByStoryboardID(identifier: "PageViewController") as! PageViewController
        pageVC.myIndex = index
        pageVC.myTitle = pageTitles[index]
        return pageVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentPageIndex
    }

}
