//
//  ViewController.swift
//  CustomTransitionTutorial
//
//  Created by Ada 2018 on 25/07/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class Screen1ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Propriedade utilziada para identificar a controller que está ocorrendo a interação
    var interactionController: UIPercentDrivenInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Criação e adição do PanGesture à view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
    //Função para realizar a custom transition apenas com um TapGesture (previamente adicionado via storyboard)
    @IBAction func handleTap(_ sender: Any) {
        performSegue(withIdentifier: "goToCongrats", sender: nil)
    }
    
    //Função para realizar a custom transition quando ocorre uma interação com PanGesture
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer){
        //pega a translate relativa ao gesture
        let translate = gesture.translation(in: gesture.view)
        
        //calculo para porcentagem do gesture
        let percent   = translate.x / gesture.view!.bounds.size.width

        //Verifica o estado do gesture
        if gesture.state == .began {
            //quando inicializa o gesture, pega a referência da controller de destino, passa a interaction controller para a interaction controller da classe TransitioningDelegate, por fim realizando o present
            let controller = storyboard!.instantiateViewController(withIdentifier: "CongratsViewController") as! CongratsViewController
            interactionController = UIPercentDrivenInteractiveTransition()
            controller.customTransitionDelegate.interactionController = interactionController
            
            present(controller, animated: true)
            
        } else if gesture.state == .changed {
            //atualiza a animação quando move o touch, baseado na porcentagem
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            //quando a interação acaba, a animação só será completa se a porcentagem da interação for maior que 50%
            if percent > 0.5 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }

}
