//
//  ViewController.swift
//  MenuExample
//
//  Created by Руслан Штыбаев on 14.06.2022.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    lazy var infoVC = InfoViewController()
    var navVC: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        addChildVC()
    }
    
    private func addChildVC() {
        // menu
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // home
        homeVC.delegate = self
        let navVc = UINavigationController(rootViewController: homeVC)
        addChild(navVc)
        view.addSubview(navVc.view)
        navVc.didMove(toParent: self)
        self.navVC = navVc
    }

}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            // open it
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut) {
                    self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
                } completion: { [weak self] done in
                    if done {
                        self?.menuState = .opened
                    }
                }
            
            
        case .opened:
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut) {
                    self.navVC?.view.frame.origin.x = 0
                } completion: { [weak self] done in
                    if done {
                        self?.menuState = .closed
                        DispatchQueue.main.async {
                            completion?()
                        }
                    }
                }
            
        }
    }
    
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didselect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .Home:
            self.resetToHome()
        case .Profile:
            self.addInfo()
        case .Accounts:
            break
        case .Transactions:
            break
        case .Stats:
            break
        case .Settings:
            break
        case .Help:
            break
        }
    }
    
    func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        homeVC.title = "Home"
    }
    
    func addInfo() {
        let vc = infoVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title
    }
}
