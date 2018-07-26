//
//  SwipeAnimationController.swift
//  CustomTransitionTutorial
//
//  Created by Ada 2018 on 26/07/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class SwipeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    //Enum para especificar o tipo de transição
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    
    //Método que realiza a animação
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        var frame = inView.bounds
        
        //Função para calcular os flips de uma rotação 3D
        func flipTransform(angle: CGFloat, offset: CGFloat = 0) -> CATransform3D {
            var transform = CATransform3DMakeTranslation(offset, 0, 0)
            transform.m34 = -1.0 / 400
            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
            return transform
        }
        
        toView.frame = inView.bounds
        toView.alpha = 0
        
        //Variáveis que armazenam os estados da animação 
        let transformFromStart:  CATransform3D
        let transformFromEnd:    CATransform3D
        let transformFromMiddle: CATransform3D
        let transformToStart:    CATransform3D
        let transformToMiddle:   CATransform3D
        let transformToEnd:      CATransform3D
        
        //Cálculo dos estados de animação para cada tipo especificado, caso estiver presenting irá realizar uma rotação da direita para esquerda, caso estiver dismissing irá realizar uma rotação da esquerda para direita
        switch transitionType {
        case .presenting:
            transformFromStart  = flipTransform(angle: 0,        offset: inView.bounds.size.width / 2)
            transformFromEnd    = flipTransform(angle: -.pi,     offset: inView.bounds.size.width / 2)
            transformFromMiddle = flipTransform(angle: -.pi / 2)
            transformToStart    = flipTransform(angle: .pi,      offset: -inView.bounds.size.width / 2)
            transformToMiddle   = flipTransform(angle: .pi / 2)
            transformToEnd      = flipTransform(angle: 0,        offset: -inView.bounds.size.width / 2)
            
            toView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            fromView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            
        case .dismissing:
            transformFromStart  = flipTransform(angle: 0,        offset: -inView.bounds.size.width / 2)
            transformFromEnd    = flipTransform(angle: .pi,      offset: -inView.bounds.size.width / 2)
            transformFromMiddle = flipTransform(angle: .pi / 2)
            transformToStart    = flipTransform(angle: -.pi,     offset: inView.bounds.size.width / 2)
            transformToMiddle   = flipTransform(angle: -.pi / 2)
            transformToEnd      = flipTransform(angle: 0,        offset: inView.bounds.size.width / 2)
            
            toView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            fromView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        }
        
        
        //Animação dos Estados previamente cálculados.
        toView.layer.transform = transformToStart
        fromView.layer.transform = transformFromStart
        inView.addSubview(toView)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.0) {
                toView.alpha = 0
                fromView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                toView.layer.transform = transformToMiddle
                fromView.layer.transform = transformFromMiddle
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.0) {
                toView.alpha = 1
                fromView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                toView.layer.transform = transformToEnd
                fromView.layer.transform = transformFromEnd
            }
        }, completion: { finished in
            
            //Reseta os transforms e os anchorPoints das views quando a animação é finalizada
            toView.layer.transform = CATransform3DIdentity
            fromView.layer.transform = CATransform3DIdentity
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            fromView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    //Tempo da animação caso não seja interativa
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}
