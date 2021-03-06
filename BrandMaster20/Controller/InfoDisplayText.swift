//
//  DisplayTextScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 08.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class InfoDisplayText: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var mainTextView: UITextView!
	@IBOutlet weak var fontSizeStepper: UIStepper! {
		didSet {
			fontSizeStepper.value = Parameters.shared.fontSize
			fontSizeStepper.minimumValue = 14
			fontSizeStepper.maximumValue = 26
		}
	}

    
	// MARK: - Global Properties
    
	var mainText = ""
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        setupInfoDisplayText()
    }
    
    
    // Сохнаняем настройки при выходе
    override func viewWillDisappear(_ animated: Bool) {
        Parameters.settings.saveSettings()
    }

    
     // MARK: - Private Methods
    
    private func setupInfoDisplayText() {
        mainTextView.text? = mainText
        let font = mainTextView.font?.fontName
        let fontSize = CGFloat(Parameters.shared.fontSize)
        mainTextView.font = UIFont(name: font!, size: fontSize)
    }
	
	// MARK: - IBActions
	
	@IBAction func fontSize(_ sender: UIStepper) {
		let font = mainTextView.font?.fontName
		let fontSize = CGFloat(sender.value)
		mainTextView.font = UIFont(name: font!, size: fontSize)
		Parameters.shared.fontSize = Double(fontSize)
	}
	
	
}
