//
//  UIApplication+.swift
//  SaiSai
//
//  Created by ch on 8/27/25.
//

import Foundation
import UIKit

extension UIApplication {
    static func popBack(_ count: Int = 1) {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root = windowScene.windows.first?.rootViewController,
            let nav = findNavigationController(root)
        else { return }
        
        let viewControllers = nav.viewControllers
        guard viewControllers.count > count else { return }
        nav.popToViewController(viewControllers[viewControllers.count - count - 1], animated: true)
    }
    
    static func popToRoot() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root = windowScene.windows.first?.rootViewController,
            let nav = findNavigationController(root)
        else { return }
        
        nav.popToRootViewController(animated: true)
    }
    
    private static func findNavigationController(_ vc: UIViewController) -> UINavigationController? {
        if let nav = vc as? UINavigationController { return nav }
        for child in vc.children {
            if let found = findNavigationController(child) { return found }
        }
        return vc.presentedViewController.flatMap { findNavigationController($0) }
    }
}
