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
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    // MARK: - Public Properties
    var currentColor: UIColor!
    unowned var delegate: BackgroundSettingsViewControllerDelegate!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRGB.backgroundColor = currentColor
        setSlidersWith(color: currentColor)
        
        viewRGB.layer.cornerRadius = 10
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        setValue(forLabel: redLabel, andTtextField: redTextField, fromSlider: redSlider)
        setValue(forLabel: greenLabel, andTtextField: greenTextField, fromSlider: greenSlider)
        setValue(forLabel: blueLabel, andTtextField: blueTextField, fromSlider: blueSlider)
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func slidersAction(_ sender: UISlider) {
        switch sender {
        case redSlider:   setValue(forLabel: redLabel, andTtextField: redTextField, fromSlider: redSlider)
        case greenSlider: setValue(forLabel: greenLabel, andTtextField: greenTextField, fromSlider: greenSlider)
        default:          setValue(forLabel: blueLabel, andTtextField: blueTextField, fromSlider: blueSlider)
        }
        updateBackgroundColor()
    }
    
    @IBAction func doneButtonTapped() {
        delegate.updateView(color: viewRGB.backgroundColor ?? .blue)
        dismiss(animated: true)
    }

}

// MARK: - Private Methods
private extension BackgroundSettingsViewController {
    func updateBackgroundColor() {
        viewRGB.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1)
    }
    
    func setValue(forLabel label: UILabel,
                  andTtextField textField: UITextField,
                  fromSlider slider: UISlider) {
        label.text = string(from: slider)
        textField.text = string(from: slider)
    }
    
    func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    func setSlidersWith(color: UIColor) {
        let ciColor = CIColor(color: currentColor)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
}

// MARK: - UITextFieldDelegate
extension BackgroundSettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            showAlert(withTitle: "Wrong format!", andMessage: "Please enter correct value")
            return
        }
        
        guard let currentValue = Float(text), (0...1).contains(currentValue) else {
            showAlert(
                withTitle: "Wrong format!",
                andMessage: "Please enter a number between 0 and 1.00",
                textField: textField)
            return
        }
        
        switch textField {
        case redTextField:
            redSlider.setValue(currentValue, animated: true)
            redLabel.text = string(from: redSlider)
        case greenTextField:
            greenSlider.setValue(currentValue, animated: true)
            greenLabel.text = string(from: greenSlider)
        default:
            blueSlider.setValue(currentValue, animated: true)
            blueLabel.text = string(from: blueSlider)
        }
        updateBackgroundColor()
    }
}

// MARK: - UIAlertController
extension BackgroundSettingsViewController {
    private func showAlert(withTitle title: String, andMessage message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            textField?.text = "1.00"
            textField?.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
