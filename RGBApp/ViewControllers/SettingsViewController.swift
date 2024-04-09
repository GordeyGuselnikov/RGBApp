//
//  ViewController.swift
//  RGBApp
//
//  Created by Guselnikov Gordey on 5/1/23.
//

import UIKit

final class SettingsViewController: UIViewController {
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
    unowned var delegate: SettingsViewControllerDelegate!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRGB.layer.cornerRadius = 10

//        redSlider.tintColor = .red
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        viewRGB.backgroundColor = currentColor
        
        setSlidersWith(currentColor)
        setValues(for: redLabel, and: redTextField, from: redSlider)
        setValues(for: greenLabel, and: greenTextField, from: greenSlider)
        setValues(for: blueLabel, and: blueTextField, from: blueSlider)
        
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
        case redSlider:
            setValues(for: redLabel, and: redTextField, from: redSlider)
        case greenSlider:
            setValues(for: greenLabel, and: greenTextField, from: greenSlider)
        default:          
            setValues(for: blueLabel, and: blueTextField, from: blueSlider)
        }
        
        setBackgroundColor()
    }
    
    @IBAction func doneButtonTapped() {
        delegate.updateColor(viewRGB.backgroundColor ?? .blue)
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    func setBackgroundColor() {
        viewRGB.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1)
    }
    
    func setValues(for label: UILabel, and textField: UITextField, from slider: UISlider) {
        label.text = string(from: slider)
        textField.text = string(from: slider)
    }
    
//    func setValue(for labels: UILabel...) {
//        labels.forEach { label in
//            switch label {
//            case redLabel: label.text = string(from: redSlider)
//            case greenLabel: label.text = string(from: greenSlider)
//            default: label.text = string(from: blueSlider)
//            }
//        }
//    }
    
    // метод конвертирует значения слайдеров в строку, округляя до .00
    func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    func setSlidersWith(_ color: UIColor) {
        let ciColor = CIColor(color: currentColor)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    
    // метод для нецифровой клавиатуры, для кнопки done/return
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder() // завершение работы с textField // скрываем клавиатуру
//    }
    
    // вызывается после resignFirstResponder() - скрытия клавиатуры
    // вызывается в момент когда закончили редактировать текстовое поле
    func textFieldDidEndEditing(_ textField: UITextField) {
        // проверка на присутствие данных в textField
        guard let text = textField.text else {
            showAlert(withTitle: "Wrong format!", andMessage: "Please enter correct value")
            return
        }
        
        // приведение данных из textField к числу(сразу к Float для слайдеров)
        // и проверка на соответсвтвие дипозону 0 до 1
        guard let currentValue = Float(text), (0...1).contains(currentValue) else {
            showAlert(
                withTitle: "Wrong format!",
                andMessage: "Please enter a number between 0.00 and 1.00") {
                    // completion
                    textField.text = "0.50"
                    textField.becomeFirstResponder() // вызов клавиатуры после нажатия кнопки ОК
                }
            return
        }
        
        switch textField {
        case redTextField:
            redSlider.setValue(currentValue, animated: true) // установка значения слайдера с Анимацией!
            redLabel.text = string(from: redSlider)
        case greenTextField:
            greenSlider.setValue(currentValue, animated: true)
            greenLabel.text = string(from: greenSlider)
        default:
            blueSlider.setValue(currentValue, animated: true)
            blueLabel.text = string(from: blueSlider)
        }
        
        setBackgroundColor()
    }
    
    // началось редактирование textField
    // вызывается еще до появления курсора и перед появлением клавиатуры
    // для работы с toolBar, который приделываем к цифровой клавиатуре
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit() // установка размера toolBar по размеру клавиатуры
        textField.inputAccessoryView = keyboardToolBar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder) // скрываем клавиатуру - этот метод есть в textField
        )
        
        // "кнопка" для заполнения пространства
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolBar.items = [flexBarButton, doneButton, flexBarButton]
    }
}

// MARK: - UIAlertController
extension SettingsViewController {
    private func showAlert(withTitle title: String, andMessage message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension Float { // такой Extension не подписываем как MARK!
    func cgFloat() -> CGFloat {
        CGFloat(self)
    }
}
