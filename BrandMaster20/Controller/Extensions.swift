//
//  Extensions.swift
//  BrandMaster20
//
//  Created by Алексей on 12.10.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extensions

extension String {
    
    // Подставляем разделитель в зависимости от системной локали
    static let numberFormatter = NumberFormatter()
    func dotGuard() -> Double {
        var doubleValue: Double {
            String.numberFormatter.decimalSeparator = ","
            if let result =  String.numberFormatter.number(from: self) {
                return result.doubleValue
            } else {
                String.numberFormatter.decimalSeparator = "."
                if let result = String.numberFormatter.number(from: self) {
                    return result.doubleValue
                }
            }
            return 0
        }
        return doubleValue
    }
    
}


extension UITableViewController {
    
    // Проверяем текстовое поле на nil
    func guardText(field: UITextField) -> Double {
        if let senderValue = field.text?.dotGuard() {
            atencionMessageForText(field: field, value: senderValue)
            return senderValue
        }
        return 0.0
    }
    
    
    // Выводим предупреждение если значение некорректное или равно 0
    func atencionMessageForText(field: UITextField, value: Double) {
        let zeroType = Parameters.shared.deviceType == .air ? "0" : "0.0"
        guard value != 0.0
            else {
                let alert = UIAlertController(title: "Пустое поле!",
                                              message: "Значение будет равно \(zeroType)",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil))
                present(alert, animated: true, completion: nil)
                field.text = zeroType
                return
        }
    }
    
}


extension UITextField {
    
    func textFieldCorrect(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.)
        if textField.text?.count == 0 && string == "0" {

            return false
        }

        //Limit the character count to 10.
        if ((textField.text!) + string).count > 5 {

            return false
        }

        //Have a decimal keypad. Which means user will be able to enter Double values. (Needless to say "." will be limited one)
        if (textField.text?.contains("."))! && string == "." {

            return false
        }

        //Only allow numbers. No Copy-Paste text values.
        let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
        let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
        if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
            return false
        }
        return true
    }
}
