
import UIKit

class MainScreen: UITableViewController {
    
    // MARK: - IBOutlets
    
    // Section 0
	@IBOutlet weak var fireStatusLabel: UILabel!
    @IBOutlet weak var workStatusLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var fireTimeLabel: UILabel!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var fireTimePicker: UIDatePicker!
    @IBOutlet weak var fireplaceSwitch: UISwitch!
    @IBOutlet weak var workConditionSwitch: UISwitch!
    
    
    // Section 1
    @IBOutlet weak var teamSizeStepper: UIStepper! {
        didSet {
			teamSizeStepper.value = Double(Parameters.shared.teamSize)
            teamSizeStepper.minimumValue = 2
            teamSizeStepper.maximumValue = 5
			teamSizeStepper.isEnabled = fireplaceSwitch.isOn ? true : false
        }
    }
    
	@IBOutlet weak var enterLabel: UILabel!
	
	@IBOutlet weak var fireplaceLabel: UILabel!
	@IBOutlet weak var firstRowLabel: UILabel!
	
    @IBOutlet var firemanData: [UIStackView]!
    @IBOutlet var startDataTextFields: [UITextField]!
    @IBOutlet var fireDataTextFields: [UITextField]!
	
    
    // MARK: - Properties
    
    
    
	
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		Parameters.settings.loadDefaultSettings()
        Parameters.settings.loadSettings()
        setupStartScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let teamSize: Int
        teamSize = fireplaceSwitch.isOn ? Parameters.shared.teamSize : 1
        teamSizeStepper.value = Double(teamSize)
            
        showTeamRow(size: teamSize)
    }
	
	override func viewDidDisappear(_ animated: Bool) {
//        readPressureData(Parameters.shared.teamSize)
        
        Parameters.settings.saveSettings()
		print("Pressure save")
	}
    
   
    // MARK: - Private Methods
    
    private func setupStartScreen() {
        // Скрываем клавиатуру свайпом
        tableView.keyboardDismissMode = .onDrag
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Условия работы"
        
        fireplaceSwitch.isOn = Parameters.shared.isFireFound
        workConditionSwitch.isOn = Parameters.shared.isHardWork
        
        fireStatusLabel.text = fireplaceSwitch.isOn ? "Очаг - обнаружен" : "Очаг - поиск"
        workStatusLabel.text = workConditionSwitch.isOn ? "Условия - сложные" : "Условия - нормальные"
        
        setTime(for: startTimeLabel, from: startTimePicker)
        setTime(for: fireTimeLabel, from: fireTimePicker)
         
        showTeamRow(size: Parameters.shared.teamSize)
        
    }
    
    
    private func setTime(for label: UILabel, from picker: UIDatePicker) {
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        label.text = time.string(from: picker.date)
    }
    
    
    private func showTeamRow(size: Int) {
        // Скрываем все поля ввода
        for item in firemanData {
            item.isHidden  = true
        }
        // Показываем только необходимое количество строк ввода
        for i in 0..<(size) {
            firemanData[i].isHidden = false
        }
        writePressure(size)
    }
    
    // Заполняем TextFields данными
    private func writePressure(_ size: Int) {
        for i in 0..<(size) {
            
            var enterValue = String()
            var fireValue = String()
            
        print(Parameters.shared.enterPressureData)
            switch Parameters.shared.measureType {
            case .kgc:
                enterValue = String(Int(Parameters.shared.enterPressureData[i]))
                fireValue = String(Int(Parameters.shared.firePressureData[i]))
            case .mpa:
                enterValue = String(Parameters.shared.enterPressureData[i])
                fireValue = String(Parameters.shared.firePressureData[i])
            }
            
            startDataTextFields?[i].text = enterValue
            fireDataTextFields?[i].text = fireValue
        }
    }
    
    
    //  Получаем значения из полей ввода
    private func readPressureData(_ size: Int) {
        var enterArray = [Double]()
        var fireArray = [Double]()
		
		
        for i in 0..<(size) {
            if let enterData = startDataTextFields?[i].text, let fireData = fireDataTextFields?[i].text {
				enterArray.append(Double(enterData) ?? 0.0)
				fireArray.append(Double(fireData) ?? 0.0)
				
            }
        }
        Parameters.shared.setPressureData(for: enterArray, for: fireArray)
		atencionMessage()
    }

    
    private func showFireUI() {
        fireTimeCellHidden = !fireTimeCellHidden
        fireTimePickerHidden = true
        fireplaceLabel.isHidden = !fireplaceLabel.isHidden
        
        if fireTimeCellHidden {
            fireDataTextFields.forEach {
                $0.isHidden = true
            }
        } else {
            fireDataTextFields.forEach {
                $0.isHidden  = false
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func calculate(_ sender: UIBarButtonItem) {
		readPressureData(Parameters.shared.teamSize)
		
		if Parameters.shared.showSimpleSolution {
			performSegue(withIdentifier: "toPDF", sender: self)
		} else {
			performSegue(withIdentifier: "toSimple", sender: self)
		}
    }
    
    
    @IBAction func fireFoundChange(_ sender: UISwitch) {
        fireStatusLabel.text = fireplaceSwitch.isOn ? "Очаг - обнаружен" : "Очаг - поиск"
        showFireUI()
        Parameters.shared.isFireFound = fireplaceSwitch.isOn  //
		
		switch fireplaceSwitch.isOn {
			case true:
				teamSizeStepper.isEnabled = true
				firstRowLabel.text = "1"
				enterLabel.isHidden = false
				showTeamRow(size: Parameters.shared.teamSize)
				
			case false:
				teamSizeStepper.isEnabled = false
				firstRowLabel.text = "P мин. вкл."
				enterLabel.isHidden = true
				showTeamRow(size: 1)
		}
		
		tableView.beginUpdates()
		tableView.endUpdates()
    }
    
    
    @IBAction func workStatusChange(_ sender: UISwitch) {
        workStatusLabel.text = workConditionSwitch.isOn ? "Условия - сложные" : "Условия - нормальные"
        Parameters.shared.isHardWork = workConditionSwitch.isOn   //
    }
    
    
    @IBAction func setEnterTime(_ sender: UIDatePicker) {
        setTime(for: startTimeLabel, from: sender)
        Parameters.shared.startTime = startTimePicker!.date   //
    }
    
    
    @IBAction func setFireTime(_ sender: UIDatePicker) {
        setTime(for: fireTimeLabel, from: sender)
        Parameters.shared.fireTime = fireTimePicker!.date    //
    }
    
    
    @IBAction func teamSizeChange(_ sender: UIStepper) {
		Parameters.shared.setupTeam(size: Int(sender.value))
        showTeamRow(size: Int(sender.value))
        tableView.reloadData()
    }
    
    // Получаем данные из полей ввода сразу после их ввода
    @IBAction func getPressureFromTextField(_ sender: UITextField) {
        readPressureData(Parameters.shared.teamSize)
    }
    
    
    // !!!
    @IBAction func watch(_ sender: UITextField) {
        print("watch")
        let value = Double(sender.text!)
        
        if value == nil {
            sender.layer.borderColor = UIColor.red.cgColor
        }
        else if value! <= 0 || value! > 350 {
            sender.layer.borderColor = UIColor.red.cgColor

        }
        else {
            sender.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    
   

    
    // MARK: - Table view data source
    
    private var startTimePickerHidden = true
    private var fireTimePickerHidden = true
    private var fireTimeCellHidden = false
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0, indexPath.row == 3  {
            return (startTimePickerHidden ? 0 : 216)
        }
        
        if indexPath.section == 0, indexPath.row == 4  {
            return (fireTimeCellHidden ? 0 : tableView.rowHeight)
        }
        
        if indexPath.section == 0, indexPath.row == 5 {
            return (fireTimePickerHidden ? 0 : 216)
        }
		
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            startTimePickerHidden = !startTimePickerHidden
        case (0, 4):
            fireTimePickerHidden = !fireTimePickerHidden
        default:
            ()
        }
		
        tableView.reloadRows(at: [indexPath], with: .none)
    }
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		var headerText = String()
		if section == 1 {
			switch Parameters.shared.measureType {
				case .kgc:
					headerText = "ДАВЛЕНИЕ В ЗВЕНЕ (кгс/см\u{00B2})"
				case .mpa:
					headerText = "ДАВЛЕНИЕ В ЗВЕНЕ (МПа)"
			}
		}
		return headerText
	}
    
    
     // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPDF" {
            guard let vc = segue.destination as? PDFPreviewScreen else { return }
            let pdfCreator = PDFCreator()
			
            if Parameters.shared.isFireFound {
                vc.documentData = pdfCreator.createFound()
            } else {
                vc.documentData = pdfCreator.createNotFound()
            }
        }
        
        if segue.identifier == "toSimple" {
            
        }
    }
	
	// Проверка корректности ввода
	func atencionMessage() {
		var firewall: Double
		firewall = Parameters.shared.measureType == .kgc ? 350 : 35
		
		print(Parameters.shared.enterPressureData)
		if (Parameters.shared.enterPressureData.min()! < 1 || Parameters.shared.enterPressureData.max()! > firewall) ||
			(Parameters.shared.firePressureData.min()! < 1 || Parameters.shared.firePressureData.max()! > firewall) {
			let alert = UIAlertController(title: "Некорректное значение", message: "Введите значение в пределах \n1 - \(firewall)", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
	}
    
}


