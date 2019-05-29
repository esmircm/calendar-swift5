//
//  MainViewController.swift
//  test
//
//  Created by Endalia on 29/05/2019.
//  Copyright © 2019 AppleInc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func showCalendarModal(_ sender: UIButton) {
        let popupContent = PopupContentWithDismissViewController.create()
        let cardPopup = SBCardPopupViewController(contentViewController: popupContent)
        cardPopup.show(onViewController: self)
    }

}
