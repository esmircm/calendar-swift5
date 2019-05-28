//
//  ModalViewController.swift
//  test
//
//  Created by Endalia on 28/05/2019.
//  Copyright © 2019 AppleInc. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, SBCardPopupContent {

    var popupViewController: SBCardPopupViewController?
    var allowsTapToDismissPopupCard: Bool = true
    var allowsSwipeToDismissPopupCard: Bool = true
    
    
    static func create() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeModal(_ sender: UIButton) {
        self.popupViewController?.close()
    }
    
}
