import Foundation

// Типы дыхательного аппарата
enum DeviceType: String {
    case air
    case oxigen
}


// Единицы измерения расчетов
enum MeasureType: String {
    case kgc
    case mpa
}


struct Parameters {
    
    static var shared = Parameters()
    
    private init() {}
    
    
    // MARK: - Условия работы
    
    var teamSize: Int = 3
    // Очаг найден
    var isFireFound = true
    // Сложные условия true/false
    var isHardWork = false
    // Время включения
    var startTime = Date()
    // Время у очага
    var fireTime = Date()
    // Давление при включении
    var enterPressureData = [300.0, 300.0, 300.0]
    // Давление у очага
    var firePressureData = [250.0, 250.0, 250.0]
    // Падение давления в звене
    var fallPressureData = [50.0, 50.0, 50.0] 
    
    // MARK: - Настройки приложения
    static var settings = UserSettings()
    //  Тип СИЗОД. По-умолчанию ДАСВ
    var deviceType = DeviceType.air
    // Единицы измерения.
    var measureType = MeasureType.kgc
    // Ручной ввод давления (точность)
    var accuracyMode = false
    // Учитывать звуковой сигнал в расчетах
    var airSignalMode = true
    // Показать простое решение
    var showSimpleSolution = false
    
    // Размер шрифта текста
    var fontSize = 18.0
    
    
    // MARK: - Параметры дахательного аппарата
    
    // Объем баллона
    var airVolume = 6.8
    // Средний расход воздуха
    var airRate = 40.0
    // Коэффициент сжимаемости воздуха
    var airIndex = 1.1
    // давление воздуха, необходимое для устойчивой работы редуктора
    var reductorPressure = 10.0
    // Давление срабатывания звукового сигнала
    var airSignal = 55.0
    
    var airSignalFlag = false
    
    var airFlow: Double {
        get {
            switch deviceType {
            case .air:
                return airIndex * airRate
            case .oxigen:
                return measureType == .kgc ? 2.0 : 0.2
            }
        }
    }
    
    
    
    // MARK: - Pickerview
    
    var pickerComponents = [String]()    // Содержимое pickerview
    
    mutating func generatePickerData() {
        var value = 300.0
        switch measureType {
        case .kgc:
            while value >= 100 {
                pickerComponents.append(String(Int(value)))
                value -= 5
            }
        case .mpa:
            value = 30
            while value >= 10 {
                
                pickerComponents.append(String(value))
                value -= 0.5
            }
        }
    }
    
    
    mutating func setDeviceType(device: DeviceType ) {
        switch device {
        case .air:
            deviceType = .air
            airVolume = 6.8
            airSignal = 55
        case .oxigen:
            deviceType = .oxigen
            airVolume = 1.0
            airSignal = 35
        }
    }
    
    mutating func setMeasureType(measure: MeasureType ) {
        switch measure {
        case .kgc:
            measureType = .kgc
        case .mpa:
            measureType = .mpa
        }
    }
    
    
    // Сохраняем значение давления
    mutating func setPressureData(for enterArray: [Double], for fireArray: [Double]) {
        enterPressureData.removeAll()
        firePressureData.removeAll()
        fallPressureData.removeAll()
        
        enterPressureData = enterArray
        firePressureData = fireArray
        for item in 0..<enterArray.count {
            fallPressureData.append(enterPressureData[item] - firePressureData[item])
        }
    }
    
    
    // Данные давления входа, очага, падения
    mutating func setupTeam(size: Int) {
        print("setupTeam")
        if size < self.teamSize {
            for _ in 0..<(self.teamSize - size) {
                enterPressureData.removeLast()
                firePressureData.removeLast()
                fallPressureData.removeLast()
            }
            
        } else {
            for _ in 0..<(size - self.teamSize) {
                
                switch measureType {
                case .kgc:
                    enterPressureData.append(300.0)
                    firePressureData.append(250.0)
                    fallPressureData.append(50.0)
                case .mpa:
                    enterPressureData.append(30.0)
                    firePressureData.append(25.0)
                    fallPressureData.append(5.0)
                }
            }
        }
        
        self.teamSize = size
    }
    
    
    // Конвертировать  единицы измерения
    mutating func convertValue() {
        // переводим в кг
        if measureType == .mpa {
            // Изменить значения видимых полей ввода
            for i in 0 ..< teamSize {
                enterPressureData[i] /= 10.0
                firePressureData[i] /= 10.0
                fallPressureData[i] /= 10.0
                
            }
            reductorPressure /= 10
            airRate /= 10
            airSignal /= 10
        }
        
        // переводим в MPa
        if measureType == .kgc {
            
            for i in 0 ..< enterPressureData.count {
                enterPressureData[i] *= 10.0
                firePressureData[i] *= 10.0
                fallPressureData[i] *= 10.0
            }
            reductorPressure *= 10
            airRate *= 10
            airSignal *= 10
        }
    }
    
}
