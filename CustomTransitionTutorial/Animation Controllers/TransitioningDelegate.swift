//
//  TransitioningDelegate.swift
//  CustomTransitionTutorial
//
//  Created by Ada 2018 on 26/07/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    
    //Método que retorna a animação present ao passar o transitionType como .presenting
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipAnimationController(transitionType: .presenting)
    }
    //Método que retorna a animação dismiss ao passar o transitionType como .dismissing
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipAnimationController(transitionType: .dismissing)
    }
    //Método utilizado para gerenciar as transições e animações da presented controller
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }

    //Método que é chamado quando ocorre um present de uma transição interativa
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    //Método que é chamado quando ocorre um dismiss de uma transição interativa
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    
}
