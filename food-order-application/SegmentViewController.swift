//
//  SegmentViewController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-28.
//


import UIKit

class SegmentViewController: UITabBarController {


    @IBOutlet weak var sgCont: UISegmentedControl!


    //    @IBAction func segmentViewChanged(_ sender: UISegmentedControl) {
//        self.updateSegmentView()
//    }
    lazy var previewSegmentController:PreviewSegmentController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(identifier: "PreviewSegmentController") as! PreviewSegmentController
        self.addViewControllerAsChildViewController(childViewController:viewController)
        return viewController
    }()
    lazy var categorSegmentController:CategorSegmentController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(identifier: "CategorSegmentController") as! CategorSegmentController
        self.addViewControllerAsChildViewController(childViewController:viewController)
        return viewController
    }()
    lazy var menuSegmentController:MenuSegmentController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(identifier: "MenuSegmentController") as! MenuSegmentController
        self.addViewControllerAsChildViewController(childViewController:viewController)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseService().getAllItems(){
            completion in
            self.setupView()
        }
        // Do any additional setup after loading the view.
    }
    

    private func setupView(){
        self.setupSegmentControll()
        self.updateSegmentView()
    }

    private func updateSegmentView(){
        previewSegmentController.view.isHidden = !(self.sgCont.selectedSegmentIndex==0)
        categorSegmentController.view.isHidden = !(self.sgCont.selectedSegmentIndex==1)
        menuSegmentController.view.isHidden = !(self.sgCont.selectedSegmentIndex==2)
    }

    private func setupSegmentControll(){
        self.sgCont.removeAllSegments()
        self.sgCont.insertSegment(withTitle: "Preview", at: 0, animated: false)
        self.sgCont.insertSegment(withTitle: "Category +", at: 1, animated: false)
        self.sgCont.insertSegment(withTitle: "Menu +", at: 2, animated: false)
        self.sgCont.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        self.sgCont.selectedSegmentIndex=0
    }

    @objc func selectionDidChange(sender:UISegmentedControl){
        print("##########")
        self.updateSegmentView()
    }

    func addViewControllerAsChildViewController(childViewController:UIViewController){
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame=view.bounds
        childViewController.view.autoresizingMask=[.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParent: self)
    }

    private func removeViewControllerAsChildViewController(childViewController:UIViewController){
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

