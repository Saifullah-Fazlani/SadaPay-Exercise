//
//  TestVC.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 23/06/2021.
//

import UIKit

class TestVC: UIViewController {

    @IBOutlet weak var lblTest: UILabel!
    
    var authorName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTest.text = authorName
    }

}
