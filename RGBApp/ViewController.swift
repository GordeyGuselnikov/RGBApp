//
//  ViewController.swift
//  RGBApp
//
//  Created by Guselnikov Gordey on 5/1/23.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var viewRGB: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBackgroundColor()
    }

    override func viewWillLayoutSubviews() {
        viewRGB.layer.cornerRadius = 10
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
    }
    
    @IBAction func slidersAction(_ sender: UISlider) {
        switch sender {
        case redSlider: setValue(for: redLabel, from: redSlider)
        case greenSlider: setValue(for: greenLabel, from: greenSlider)
        default: setValue(for: blueLabel, from: blueSlider)
        }
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        viewRGB.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                          green: CGFloat(greenSlider.value),
                                          blue: CGFloat(blueSlider.value),
                                          alpha: 1)
    }
    
    private func setValue(for label: UILabel, from slider: UISlider) {
            label.text = string(from: slider)
    }
    
    private func string(from slider: UISlider) -> String {
            String(format: "%.2f", slider.value)
    }
}
