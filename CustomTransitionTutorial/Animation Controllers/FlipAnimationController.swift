//
//  SwipeAnimationController.swift
//  CustomTransitionTutorial
//
//  Created by Ada 2018 on 26/07/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class FlipAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
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
        let containerView   = transitionContext.containerView
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromView = fromViewController.view,
            let toView = toViewController.view else {
                return
        }
        toView.frame = fromViewController.view.frame
        containerView.insertSubview(toView, belowSubview: fromView)
        
        // Cria um background view
        let backgroundView = UIView(frame: transitionContext.initialFrame(for: fromViewController))
        backgroundView.backgroundColor = UIColor.black
        
        containerView.addSubview(backgroundView)
        
        // Tira um snapshot(print) da presenting view e presented view
        let fromSnapshotRect = fromView.bounds
        let toSnapshotRect = toView.bounds
        guard
            let fromSnapshotView = fromView.resizableSnapshotView(from: fromSnapshotRect, afterScreenUpdates: false, withCapInsets: .zero),
            let toSnapshotView = toView.resizableSnapshotView(from: toSnapshotRect, afterScreenUpdates: true, withCapInsets: .zero) else {
                return
        }
        
        backgroundView.addSubview(fromSnapshotView)
        backgroundView.insertSubview(toSnapshotView, belowSubview: fromSnapshotView)
        
        // Função para calcular os flips de uma rotação 3D
        func flipTransform(angle: CGFloat, offset: CGFloat = 0) -> CATransform3D {
            var transform = CATransform3DMakeTranslation(offset, 0, 0)
            transform.m34 = -1.0 / 400
            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
            return transform
        }
        
        // Variáveis que armazenam os estados(keyFrames) da animação
        let transformFromStart:  CATransform3D
        let transformFromEnd:    CATransform3D
        let transformFromMiddle: CATransform3D
        let transformToStart:    CATransform3D
        let transformToMiddle:   CATransform3D
        let transformToEnd:      CATransform3D
        
        // Cálculo dos estados de animação para cada tipo especificado, caso estiver presenting irá realizar uma rotação da direita para esquerda, caso estiver dismissing irá realizar uma rotação da esquerda para direita
        switch transitionType {
        case .dismissing:
            transformFromStart  = flipTransform(angle: 0,        offset: containerView.bounds.size.width / 2)
            transformFromEnd    = flipTransform(angle: -.pi,     offset: containerView.bounds.size.width / 2)
            transformFromMiddle = flipTransform(angle: -.pi / 2)
            transformToStart    = flipTransform(angle: .pi,      offset: -containerView.bounds.size.width / 2)
            transformToMiddle   = flipTransform(angle: .pi / 2)
            transformToEnd      = flipTransform(angle: 0,        offset: -containerView.bounds.size.width / 2)
            
            toSnapshotView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            fromSnapshotView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            
        case .presenting:
            transformFromStart  = flipTransform(angle: 0,        offset: -containerView.bounds.size.width / 2)
            transformFromEnd    = flipTransform(angle: .pi,      offset: -containerView.bounds.size.width / 2)
            transformFromMiddle = flipTransform(angle: .pi / 2)
            transformToStart    = flipTransform(angle: -.pi,     offset: containerView.bounds.size.width / 2)
            transformToMiddle   = flipTransform(angle: -.pi / 2)
            transformToEnd      = flipTransform(angle: 0,        offset: containerView.bounds.size.width / 2)
            
            toSnapshotView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            fromSnapshotView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        }
        
        
        // Animação dos Estados previamente cálculados.
        
        toSnapshotView.layer.transform = transformToStart
        fromSnapshotView.layer.transform = transformFromStart
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.0) {
                toSnapshotView.alpha = 0
                fromSnapshotView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                toSnapshotView.layer.transform = transformToMiddle
                fromSnapshotView.layer.transform = transformFromMiddle
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.0) {
                toSnapshotView.alpha = 1
                fromSnapshotView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                toSnapshotView.layer.transform = transformToEnd
                fromSnapshotView.layer.transform = transformFromEnd
            }
        }, completion: { finished in
            //  Remove todas as views da super view quando a animação terminar
            fromSnapshotView.removeFromSuperview()
            toSnapshotView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            
            // Caso a animação nao seja cancelada, será completada a transição
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    //Tempo da animação caso não seja interativa 
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}
