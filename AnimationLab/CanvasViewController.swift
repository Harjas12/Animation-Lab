//
//  ViewController.swift
//  AnimationLab
//
//  Created by Harjas Monga on 2/25/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var trayView: UIView!
    
    var trayOrignalPoint: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUP: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 180
        trayUP = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
    }
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        switch sender.state {
            case .began:
                trayOrignalPoint = trayView.center
                break
            case .changed:
                trayView.center = CGPoint(x: trayOrignalPoint.x, y: trayOrignalPoint.y + translation.y)
                break
            case .ended:
                UIView.animate(withDuration: 0.4, animations: {
                    if velocity.y > 0 {
                        self.trayView.center = self.trayDown
                    } else {
                        self.trayView.center = self.trayUP
                    }
                })
            default:
                break
        }
    }
    @IBAction func facePanned(_ sender: Any) {
        let gestureRecongizer = sender as! UIPanGestureRecognizer
        let translation = gestureRecongizer.translation(in: self.view)
        switch gestureRecongizer.state {
            case .began:
                let imageView = gestureRecongizer.view as! UIImageView
                newlyCreatedFace = UIImageView(image: imageView.image)
                self.view.addSubview(newlyCreatedFace)
                newlyCreatedFace.center = imageView.center
                newlyCreatedFace.center.y += trayView.frame.origin.y
                newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
                break
            case .changed:
                newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
                break
            case .ended:
                break
            default:
                break
            
        }
    }
}

