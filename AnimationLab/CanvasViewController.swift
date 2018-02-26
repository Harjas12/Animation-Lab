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
    @IBOutlet weak var arrowView: UIImageView!
    
    var trayOrignalPoint: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUP: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var previousScale: CGFloat = 1
    let sizeOfOriginal: CGFloat = 120
    
    let hapticFeedBack = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 205
        trayUP = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
    }
    @objc func didPanInCanvas(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        switch sender.state {
            case .began:
                newlyCreatedFace = sender.view as! UIImageView
                newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
                previousScale = newlyCreatedFace.frame.size.height / sizeOfOriginal
                let yScale: CGFloat = 2
                UIView.animate(withDuration: 0.2, animations: {
                    self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: yScale)
                })
            case .changed:
                newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
                break
            case .ended:
                UIView.animate(withDuration: 0.2, animations: {
                    self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: self.previousScale, y: self.previousScale)
                })
                hapticFeedBack.impactOccurred()
                break
            default:
                break
        }
    }
    @objc func didPinchInCanvas(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
    @objc func didRotate(gestureRecognizer: UIRotationGestureRecognizer) {
        let rotation = gestureRecognizer.rotation
        newlyCreatedFace = gestureRecognizer.view as! UIImageView
        newlyCreatedFace.transform = newlyCreatedFace.transform.rotated(by: rotation)
        gestureRecognizer.rotation = 0
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
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    if velocity.y > 0 {
                        self.trayView.center = self.trayDown
                        self.arrowView.transform = CGAffineTransform(rotationAngle: .pi)
                    } else {
                        self.trayView.center = self.trayUP
                        self.arrowView.transform = CGAffineTransform(rotationAngle: (2 * .pi))
                    }
                })
                hapticFeedBack.impactOccurred()
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
                let yScale: CGFloat = 2
                UIView.animate(withDuration: 0.2, animations: {
                    self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: yScale)
                })
                newlyCreatedFace.isUserInteractionEnabled = true
                newlyCreatedFace.clipsToBounds = true
                newlyCreatedFace.contentMode = .scaleAspectFill
                break
            case .changed:
                newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
                break
            case .ended:
                let newPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didPanInCanvas(sender:)))
                let newPinchGestureRecongizer = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinchInCanvas(sender:)))
                let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.didRotate(gestureRecognizer:)))
                newlyCreatedFace.addGestureRecognizer(newPanGestureRecognizer)
                newlyCreatedFace.addGestureRecognizer(newPinchGestureRecongizer)
                newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
                UIView.animate(withDuration: 0.2, animations: {
                    self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 1.5, y: 1.5)
                })
                hapticFeedBack.impactOccurred()
                break
            default:
                break
            
        }
    }
}

