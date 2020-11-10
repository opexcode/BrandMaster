//
//  SimpleSolutionScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 18.10.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation
import UIKit

class SimpleSolutionScreen: UITableViewController {
	
//	var appData: SettingsData!
	var listNotFound = [String]()
	var listFound = [String]()
	let detailNotFound = ["Максимально допустимое падение давления в звене, Pмакс.пад.",
						  "Давление при котором звену необходимо начать выход из НДС, Рк.вых.",
						  "Промежуток времени с момента включения до подачи постовым команды на выход, \u{0394}T.",
						  "Время подачи постовым команды на выход, Tвых."]
	
	let detailFound = ["Общее время работы звена, Тобщ.",
					   "Ожидаемое время возвращения звена из НДС, Твозвр.",
					   "Давление при котором звену необходимо выходить из НДС, Рк.вых.",
					   "Время работы звена у очага, Траб.",
					   "Время подачи команды постовым на выход звена из НДС, Тк.вых."]
	
	let value = Parameters.shared.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Parameters.shared.isFireFound ? fireFound() : fireNotFound()
		atencionMessage()
	}

	
	func fireNotFound() {
		let comp = Calculations()
		// 1) Расчет максимального возможного падения давления при поиске очага
		let maxDrop = comp.maxDropCalculation(minPressure: Parameters.shared.enterPressureData, hardChoice: Parameters.shared.isHardWork)

		// 2) Расчет давления к выходу
		let exitPressure = comp.exitPressureCalculation(minPressure: Parameters.shared.enterPressureData, maxDrop: maxDrop)

		// 3) Расчет промежутка времени с вкл. до подачи команды дТ
		let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)

		// 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
		let exitTime = comp.expectedTimeCalculation(inputTime: Parameters.shared.startTime, totalTime: timeDelta)


		// Максимальное падение давления
		let maxDropString = Parameters.shared.measureType == .kgc ? (String(Int(maxDrop))) : (String(format:"%.1f", floor(maxDrop * 10) / 10))

		// Давление к выходу
		let exitPString = Parameters.shared.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", exitPressure))

		listNotFound.append("\(maxDropString) \(value)")
		listNotFound.append("\(exitPString) \(value)")
		listNotFound.append("\(Int(timeDelta)) мин.")
		listNotFound.append(exitTime)
	}
	
	func fireFound() {
		let comp = Calculations()
	
		// 1) Расчет общего времени работы (Тобщ)
		let totalTime = comp.totalTimeCalculation(minPressure: Parameters.shared.enterPressureData)
	
		// 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
		let expectedTime = comp.expectedTimeCalculation(inputTime: Parameters.shared.startTime, totalTime: totalTime)
	
		// 3) Расчет давления для выхода (Рк.вых)
		var exitPressure = comp.exitPressureCalculation(maxDrop: Parameters.shared.fallPressureData, hardChoice: Parameters.shared.isHardWork)
	
		
		
		if Parameters.shared.airSignalMode {
			if exitPressure < Parameters.shared.airSignal {
				exitPressure = Parameters.shared.airSignal
				print(exitPressure)
				Parameters.shared.airSignalFlag = true
			}
		}
		
		// Pквых округлям при кгс и не меняем при МПа
		let exitPString = Parameters.shared.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
		
		// 4) Расчет времени работы у очага (Траб)
		let workTime = comp.workTimeCalculation(minPressure: Parameters.shared.firePressureData, exitPressure: exitPressure)
		
		// 5) Время подачи команды постовым на выход звена
		let  exitTime = comp.expectedTimeCalculation(inputTime: Parameters.shared.fireTime, totalTime: workTime)

		listFound.append("\(Int(totalTime)) мин.")
		listFound.append("\(expectedTime)")
		listFound.append("\(exitPString) \(value)")
		listFound.append("\(Int(workTime)) мин.")
		listFound.append("\(exitTime)")
	}
	
	
	
	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return Parameters.shared.isFireFound ? listFound.count : listNotFound.count
	}

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		if Parameters.shared.isFireFound {
			cell.textLabel?.text = self.listFound[indexPath.row]
			cell.detailTextLabel?.text = self.detailFound[indexPath.row]
		} else {
			cell.textLabel?.text = self.listNotFound[indexPath.row]
			cell.detailTextLabel?.text = self.detailNotFound[indexPath.row]
		}
		
		cell.detailTextLabel?.numberOfLines = 0
		cell.detailTextLabel?.textColor = .systemGray
		cell.detailTextLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)!
		
		return cell
	}

	
	// Выход по звуковому сигналу
	func atencionMessage() {
		let signal = Parameters.shared.measureType == .kgc ? (String(Int(Parameters.shared.airSignal))) : (String(format:"%.1f", Parameters.shared.airSignal))
		if Parameters.shared.airSignalMode {
			if Parameters.shared.airSignalFlag {
				let alert = UIAlertController(title: "Внимание!", message: "Выход по звуковому сигналу\n\(signal) \(value)", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				present(alert, animated: true, completion: nil)
				Parameters.shared.airSignalFlag = false
				return
			}
		}
	}
}

