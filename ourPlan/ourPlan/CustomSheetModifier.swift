//
//  CustomSheetModifier.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/17/24.
//

import Foundation
import UIKit

class CustomSheetPresentationController: UIPresentationController {
    var preferredHeight: CGFloat = 300
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        let containerViewBounds = containerView.bounds
        return CGRect(x: 0, y: containerViewBounds.height - preferredHeight, width: containerViewBounds.width, height: preferredHeight)
    }
}

class CustomPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var preferredHeight: CGFloat = 300
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.preferredHeight = preferredHeight
        return presentationController
    }
}
