//
//  SettingsMeasureType.swift
//  BrandMaster20
//
//  Created by Алексей on 09.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SettingsMeasureType: UITableViewController {

   // MARK: - IBOutlets
	@IBOutlet weak var firstCell: UITableViewCell!
	@IBOutlet weak var secondCell: UITableViewCell!
	
	@IBOutlet weak var firstCellLabel: UILabel!
	@IBOutlet weak var secondCellLabel: UILabel!

	
	
	// MARK: - LifeCircle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupMeasureScreen()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updateMeasureScreen()
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        Parameters.settings.saveSettings()
        print("MeasureType save")
    }
	
	
	// MARK: - Private Methods
	
	private func setupMeasureScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Единицы"
		
		firstCell.accessoryType = .checkmark
		
		firstCellLabel.text = "кгс/см\u{00B2}"
		secondCellLabel.text = "МРа"
	}
	
	private func updateMeasureScreen() {
		firstCell.accessoryType = Parameters.shared.measureType == .kgc ? .checkmark : .none
		secondCell.accessoryType = Parameters.shared.measureType == .mpa ? .checkmark : .none
	}
	
    
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		if indexPath.section == 0 {
			switch indexPath.row {
                // кгс/см2
				case 0:
                    if Parameters.shared.measureType == .mpa {
                        Parameters.shared.setMeasureType(measure: .kgc)
                        firstCell.accessoryType = .checkmark
                        secondCell.accessoryType = .none
                        
                        Parameters.shared.convertValue()
                        print("Измерение в кгс/см\u{00B2}")
                    }
                
                // МПа
				case 1:
                    if Parameters.shared.measureType == .kgc {
                        Parameters.shared.setMeasureType(measure: .mpa)
                        firstCell.accessoryType = .none
                        secondCell.accessoryType = .checkmark
                        
                        Parameters.shared.convertValue()
                        print("Измерение в MPa")
                    }
                    
				default:
                    break
			}
            
			tableView.reloadData()
		}
	}

}
