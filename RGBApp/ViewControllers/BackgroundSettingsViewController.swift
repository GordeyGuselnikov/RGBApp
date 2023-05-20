//
//  ViewController.swift
//  RGBApp
//
//  Created by Guselnikov Gordey on 5/1/23.
//

import UIKit

final class BackgroundSettingsViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var viewRGB: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRGB.layer.cornerRadius = 10
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        updateBackgroundColor()
        setValue(forLabel: redLabel, fromSlider: redSlider)
        setValue(forLabel: greenLabel, fromSlider: greenSlider)
        setValue(forLabel: blueLabel, fromSlider: blueSlider)
    }
    
    // MARK: - IBActions
    @IBAction func slidersAction(_ sender: UISlider) {
        switch sender {
        case redSlider:   setValue(forLabel: redLabel, fromSlider: redSlider)
        case greenSlider: setValue(forLabel: greenLabel, fromSlider: greenSlider)
        default:          setValue(forLabel: blueLabel, fromSlider: blueSlider)
        }
        updateBackgroundColor()
    }
    
    // MARK: - Private Methods
    private func updateBackgroundColor() {
        viewRGB.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(forLabel label: UILabel, fromSlider slider: UISlider) {
        label.text = string(from: slider)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}
