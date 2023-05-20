//
//  FirstViewController.swift
//  RGBApp
//
//  Created by Guselnikov Gordey on 5/20/23.
//

import UIKit

final class FirstViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let backgroundSettingsVC = segue.destination as? BackgroundSettingsViewController else { return }
        backgroundSettingsVC.delegate = self
        backgroundSettingsVC.currentColor = view.backgroundColor
    }
    
}

// MARK: - BackgroundSettingsViewControllerDelegate
extension FirstViewController: BackgroundSettingsViewControllerDelegate {
    func updateView(color: UIColor) {
        view.backgroundColor = color
    }
}
