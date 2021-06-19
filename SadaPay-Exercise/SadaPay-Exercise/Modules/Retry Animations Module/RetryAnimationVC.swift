//
//  RetryAnimationVC.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 20/06/2021.
//

import UIKit
import Lottie

class RetryAnimationVC: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    
    var animationView: AnimationView?
    var delegate: RetryDelegate?
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        initViews()
    }
    
    @IBAction func onBtnRetry(_ sender: Any) {
        delegate?.didTappedRetry()
    }
    
    func setupAnimation() {
        animationView = .init(name: "Retry-Animation")
        animationView?.frame = containerView.bounds
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1.0
        containerView.addSubview(animationView!)
        animationView?.play()
    }
    
    func initViews() {
        btnRetry.setBorders(width: 1.0, color: UIColor(named: "App-Green")!, cornerRadius: 4.0)
        lblSecond.text = errorMessage!
    }
}
