//
//  FirstViewController.swift
//  RGBApp
//
//  Created by Guselnikov Gordey on 5/20/23.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updateColor(_ color: UIColor)
}

final class MainViewController: UIViewController {
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.delegate = self
        settingsVC.currentColor = view.backgroundColor // инициализируем св-во currentColor при переходе по сегвею
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func updateColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
