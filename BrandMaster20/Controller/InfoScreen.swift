//
//  InfoScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 08.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class InfoScreen: UITableViewController, MFMailComposeViewControllerDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupInfoScreen()
	}
	
	
	// MARK: - Private Methods
	
	private func setupInfoScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Информация"
	}
	
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// Оценить приложение
		/*
		if indexPath.section == 1, indexPath.row == 0 {
			DispatchQueue.main.async {
				SKStoreReviewController.requestReview()
			}
		}
		*/
		
		if indexPath.section == 1, indexPath.row == 0 {
			if let url = URL(string: "https://apps.apple.com/ru/app/id1508823670") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		// ВК
		if indexPath.section == 1, indexPath.row == 1 {
			if let url = URL(string: "https://vk.com/brmeister") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		// Обратная связь
		if indexPath.section == 1, indexPath.row == 2 {
			let email = "bmasterfire@gmail.com"
			if let url = URL(string: "mailto:\(email)") {
				if #available(iOS 10.0, *) {
					UIApplication.shared.open(url)
				} else {
					UIApplication.shared.openURL(url)
				}
			}
		}
		
		// Политика конфеденциальности
		if indexPath.section == 1, indexPath.row == 3 {
			if let url = URL(string: "https://alekseyorehov.github.io/BrandMaster/") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		
		tableView.reloadRows(at: [indexPath], with: .none)
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
		if section == 1 {
			let header = UILabel()
			let version = UILabel()
			let copyright = UILabel()
			
			header.frame = CGRect.init(x: 0, y: 15, width: headerView.frame.width-0, height: headerView.frame.height-10)
			version.frame = CGRect.init(x: 0, y: 38, width: headerView.frame.width-0, height: headerView.frame.height-10)
			copyright.frame = CGRect.init(x: 0, y: 61, width: headerView.frame.width-0, height: headerView.frame.height-10)
			//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			
			header.text = "БрандМастер - ГДЗС"
			version.text = "Версия 0.9.8"
			copyright.text = "\u{00A9} Aleksey Orekhov"
			header.textAlignment = .center
			version.textAlignment = .center
			copyright.textAlignment = .center
			header.font = UIFont.systemFont(ofSize: 14.0)
			version.font = UIFont.systemFont(ofSize: 14.0)
			copyright.font = UIFont.systemFont(ofSize: 14.0)
			header.textColor = .systemGray
			version.textColor = .systemGray
			copyright.textColor = .systemGray
			
			//        headerView.addSubview(imageView)
			headerView.addSubview(header)
			headerView.addSubview(version)
			headerView.addSubview(copyright)
		}
		return headerView
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toMarks" {
			guard let vc = segue.destination as? PDFPreviewScreen else { return }
			let pdfCreator = PDFCreator()
			// Делаем shareButton неактивной иначе грохнется при нажатии на нее
			vc.shareButton.isEnabled = false
			vc.documentData = pdfCreator.marksViewer()
		}
	}
	

}
