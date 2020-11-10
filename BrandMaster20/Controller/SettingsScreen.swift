//
//  SettingsScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 30.07.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SettingsScreen: UITableViewController {
	
	// MARK: - IBOutlets
	
	// Section 0
	@IBOutlet weak var deviceTypeDetailLabel: UILabel!
	@IBOutlet weak var measureTypeDetailLabel: UILabel!
	
	@IBOutlet weak var accuracySwitch: UISwitch!
	@IBOutlet weak var signalSwitch: UISwitch!
	@IBOutlet weak var showSimpleSwitch: UISwitch!
	
	// Section 1
	@IBOutlet weak var airRateDetailLabel: UILabel!
	@IBOutlet weak var reductorDetailLabel: UILabel!
	@IBOutlet weak var airSignalDetaillabel: UILabel!
	
	@IBOutlet weak var airRateCell: UITableViewCell!
	@IBOutlet weak var airIndexCell: UITableViewCell!
	
	@IBOutlet weak var airVolumeTextField: UITextField!
	@IBOutlet weak var airRateTextField: UITextField!
	@IBOutlet weak var airIndexTextField: UITextField!
	@IBOutlet weak var reductorPressureTextField: UITextField!
	@IBOutlet weak var airSignalTextField: UITextField!
	
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSettingsScreen()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		updateSettingsScreen()
	}
    
    // Сохнаняем настройки при выходе
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Parameters.settings.saveSettings()
    }
	
	
	// MARK: - Private Methods
	
	private func setupSettingsScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Настройки"
		
		tableView.keyboardDismissMode = .onDrag
		
		updateSettingsScreen()
	}
	
	private func updateSettingsScreen() {
		
		accuracySwitch.isOn = Parameters.shared.accuracyMode
		signalSwitch.isOn = Parameters.shared.airSignalMode
		showSimpleSwitch.isOn = Parameters.shared.showSimpleSolution
		
		airVolumeTextField.text = String(Parameters.shared.airVolume)
		airRateTextField.text = String(Parameters.shared.airRate)
		airIndexTextField.text = String(Parameters.shared.airIndex)
        reductorPressureTextField.text = String(Parameters.shared.reductorPressure)
		airSignalTextField.text = String(Parameters.shared.airSignal)
		
		switch Parameters.shared.deviceType {
			case .air:
				deviceTypeDetailLabel.text = "ДАСВ"
				airRateDetailLabel.text = "Средний расход воздуха (л/мин)"
				reductorDetailLabel.text = "Давление редуктора (кгс/см\u{00B2})"
			case .oxigen:
				deviceTypeDetailLabel.text = "ДАСК"
				reductorDetailLabel.text = "Давление редуктора (MPa)"
		}
		
		switch Parameters.shared.measureType {
			case .kgc:
				measureTypeDetailLabel.text = "кгс/см\u{00B2}"
				reductorDetailLabel.text = "Давление редуктора (кгс/см\u{00B2})"
				airSignalDetaillabel.text = "Срабатывание сигнала (кгс/см\u{00B2})"
			case .mpa:
				measureTypeDetailLabel.text = "МПа"
				reductorDetailLabel.text = "Давление редуктора (МПа)"
				airSignalDetaillabel.text = "Срабатывание сигнала (МПа)"
		}
		tableView.reloadData()
	}
	
	// MARK: - IBActions

    // Режим "Точность"
	@IBAction func accuracyModeChange(_ sender: UISwitch) {
		Parameters.shared.accuracyMode = accuracySwitch.isOn
	}
	
    // Учитывать сигнал
	@IBAction func airSignalModeChange(_ sender: UISwitch) {
		Parameters.shared.airSignalMode = signalSwitch.isOn
		print(signalSwitch.isOn)
	}
	
    // Подробное решение
	@IBAction func simpleSolutionModeChange(_ sender: UISwitch) {
		Parameters.shared.showSimpleSolution = showSimpleSwitch.isOn
	}
	
    
    // Параметры СИЗОД
	@IBAction func setAirVolume(_ sender: UITextField) {
		Parameters.shared.airVolume = guardText(field: sender)
	}
	
	@IBAction func setAirRate(_ sender: UITextField) {
		Parameters.shared.airRate = guardText(field: sender)
	}
	
	@IBAction func setAirIndex(_ sender: UITextField) {
		Parameters.shared.airIndex = guardText(field: sender)
	}
	
	@IBAction func setReductorPressure(_ sender: UITextField) {
		Parameters.shared.reductorPressure = guardText(field: sender)
	}
	
	@IBAction func setAirSignal(_ sender: UITextField) {
		Parameters.shared.airSignal = guardText(field: sender)
	}
	
    
    // Сбросить настройки
	@IBAction func resetSettings(_ sender: UIButton) {
		let alert = UIAlertController(title: "Сбросить настройки?", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] action in
			Parameters.settings.loadDefaultSettings()
			updateSettingsScreen()
			tableView.reloadData()
		}))
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
		return
	}
	
	
	
    
	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 1 ,indexPath.row == 1 {
				return (Parameters.shared.deviceType == .oxigen) ? 0 : tableView.rowHeight
		}
		
		if indexPath.section == 1 ,indexPath.row == 2 {
				return (Parameters.shared.deviceType == .oxigen) ? 0 : tableView.rowHeight
		}
		return tableView.rowHeight
	}
}


