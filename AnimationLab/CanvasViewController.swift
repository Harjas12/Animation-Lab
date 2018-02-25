//
//  ViewController.swift
//  AnimationLab
//
//  Created by Harjas Monga on 2/25/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var trayView: UIView!
    
    var trayOrignalPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        switch sender.state {
            case .began:
                trayOrignalPoint = trayView.center
                break
            case .changed:
                trayView.center = CGPoint(x: trayOrignalPoint.x, y: trayOrignalPoint.y + translation.y)
                break
            default:
                break
        }
    }
}

