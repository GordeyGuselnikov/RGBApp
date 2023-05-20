//
//  FirstViewController.swift
//  RGBApp
//
//  Created by Guselnikov Gordey on 5/20/23.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let backgroundSettingsVC = segue.destination as? BackgroundSettingsViewController else { return }
        backgroundSettingsVC.currentColor = view.backgroundColor
    }
    
}
