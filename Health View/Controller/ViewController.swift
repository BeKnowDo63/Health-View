//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthKit = HealthKit()
    let user = User()
    var timer = Timer()
    var queryStartDate = Date()
    var queryEndDate = Date()

        
    @IBOutlet weak var dietaryCalorieLabel: UILabel!
    @IBOutlet weak var activeCalorieLabel: UILabel!
    @IBOutlet weak var basalEnergyLabel: UILabel!
    @IBOutlet weak var netCaloriesLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerChanged(_ sender: Any) {

        updateLabels()
    }
    
    @IBAction func updateLabelButton(_ sender: Any) {
        updateLabels()
    }
    
    func updateLabels() {
        
        healthKit.readDietaryEnergy(date: datePicker.date)
        healthKit.readActiveEnergy(date: datePicker.date)
        healthKit.readBasalEnergy(date: datePicker.date)

        let userDietEnergy = String(format: "%0.0f", healthKit.userDietaryEnergy)
        dietaryCalorieLabel.text = String("\(userDietEnergy)")
        let userActiveEnergy = String(format: "%0.0f", healthKit.userActiveEnergy)
        activeCalorieLabel.text = String("\(userActiveEnergy)")
        let userBasalEnergy = String(format: "%0.0f", healthKit.userBasalEnergy)
        basalEnergyLabel.text = String("\(userBasalEnergy)")
        let userNetCalories = healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy
        let userNetString = String(format: "%0.0f", userNetCalories)
        if userNetCalories <= 0 {
            netCaloriesLabel.setValue(UIColor.green, forKey: "textColor")
        } else {
            netCaloriesLabel.setValue(UIColor.red, forKey: "textColor")
        }
        netCaloriesLabel.text = String("\(userNetString)")

    }
    
    //MARK: - Timer Action
    @objc func timerAction(_ timer: Timer) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthKit.isHealthKitAvailable()
        healthKit.getHealthKitPermission()
                
        updateLabels()
    }


}

