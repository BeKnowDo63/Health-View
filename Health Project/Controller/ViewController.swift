//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthKit = HealthKit()
    let user = User()
    var timer = Timer()
    var queryStartDate = Date()
    var queryEndDate = Date()
    var meditationGoal : Double = 20.0
    var sleepGoal : Double = 10.0
    var activityGoal : Double = 600.0
    var dietaryGoal : Double = 1400.0
    var netCalorieGoal : Double = -750.0

    //MARK: - IBOutlets
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
    
    @IBOutlet weak var meditationProgressBar: UIProgressView!
    @IBOutlet weak var sleepProgressBar: UIProgressView!
    @IBOutlet weak var activityProgressBar: UIProgressView!
    @IBOutlet weak var netProgressBar: UIProgressView!
    @IBOutlet weak var dietaryProgressBar: UIProgressView!
    
    //MARK: - Update Labels
    func updateLabels() {
        
        healthKit.readDietaryEnergy(date: datePicker.date)
        healthKit.readActiveEnergy(date: datePicker.date)
        healthKit.readBasalEnergy(date: datePicker.date)
        healthKit.readMindfulMinutes(date: datePicker.date)
        healthKit.readSleepAnalysis(date: datePicker.date)

        let userDietEnergy = String(format: "%0.0f", healthKit.userDietaryEnergy)
        dietaryCalorieLabel.text = String("\(userDietEnergy)")
        let userActiveEnergy = String(format: "%0.0f", healthKit.userActiveEnergy)
        activeCalorieLabel.text = String("\(userActiveEnergy)")
        let userBasalEnergy = String(format: "%0.0f", healthKit.userBasalEnergy)
        basalEnergyLabel.text = String("\(userBasalEnergy)")
        let userNetCalories = healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy
        let userNetString = String(format: "%0.0f", userNetCalories)
        if userNetCalories <= 0 {
            netCaloriesLabel.setValue(UIColor.blue, forKey: "textColor")
        } else {
            netCaloriesLabel.setValue(UIColor.red, forKey: "textColor")
        }
        netCaloriesLabel.text = String("\(userNetString)")
        
        updateMeditationProgressBar()
        updateSleepProgressBar()
        updateActivityProgressBar()
        updateDietaryProgressBar()
        updateNetProgressBar()

    }
    
    @objc func updateMeditationProgressBar() {
        
        meditationProgressBar.progress = 0.8
        meditationProgressBar.setProgress(meditationProgressBar.progress, animated: true)
        
    }
    
    @objc func updateSleepProgressBar() {
        
        sleepProgressBar.progress = 0.9
        sleepProgressBar.setProgress(sleepProgressBar.progress, animated: true)
        
    }
    
    @objc func updateActivityProgressBar() {
        
        if healthKit.userActiveEnergy / activityGoal < 0.5 {
            activityProgressBar.progress = Float(healthKit.userActiveEnergy / activityGoal)
            activityProgressBar.progressTintColor = .red
            activityProgressBar.setProgress(activityProgressBar.progress, animated: true)
        } else if healthKit.userActiveEnergy / activityGoal < 0.90 {
            activityProgressBar.progress = Float(healthKit.userActiveEnergy / activityGoal)
            activityProgressBar.progressTintColor = .yellow
            activityProgressBar.setProgress(activityProgressBar.progress, animated: true)
        } else if healthKit.userActiveEnergy / activityGoal >= 0.90 {
            activityProgressBar.progress = Float(healthKit.userActiveEnergy / activityGoal)
            activityProgressBar.progressTintColor = .green
            activityProgressBar.setProgress(activityProgressBar.progress, animated: true)
        }
        
    }
    
    @objc func updateDietaryProgressBar() {
        
        if Float(healthKit.userDietaryEnergy) / Float(dietaryGoal) < 0.50 {
            dietaryProgressBar.progress = Float(healthKit.userDietaryEnergy) / Float(dietaryGoal)
            dietaryProgressBar.progressTintColor = .red
            dietaryProgressBar.setProgress(dietaryProgressBar.progress, animated: true)
        } else if Float(healthKit.userDietaryEnergy) / Float(dietaryGoal) < 0.90 {
            dietaryProgressBar.progress = Float(healthKit.userDietaryEnergy) / Float(dietaryGoal)
            dietaryProgressBar.progressTintColor = .yellow
            dietaryProgressBar.setProgress(dietaryProgressBar.progress, animated: true)
        } else if Float(healthKit.userDietaryEnergy) / Float(dietaryGoal) >= 0.90 {
            dietaryProgressBar.progress = Float(healthKit.userDietaryEnergy) / Float(dietaryGoal)
            dietaryProgressBar.progressTintColor = .green
            dietaryProgressBar.setProgress(dietaryProgressBar.progress, animated: true)
        }
        
    }
    
    @objc func updateNetProgressBar() {
        
        if  Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal) > 0.0 && Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal) < 0.50 {
            netProgressBar.progress = Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal)
            netProgressBar.progressTintColor = .red
            netProgressBar.setProgress(netProgressBar.progress, animated: true)
        } else if Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal) < 0.90 && Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal) >= 0.50 {
            netProgressBar.progress = Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal)
            netProgressBar.progressTintColor = .yellow
            netProgressBar.setProgress(netProgressBar.progress, animated: true)
        } else if Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal) >= 0.90 {
            netProgressBar.progress = Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal)
            netProgressBar.progressTintColor = .green
            netProgressBar.setProgress(netProgressBar.progress, animated: true)
        } else if Float(healthKit.userDietaryEnergy - healthKit.userBasalEnergy - healthKit.userActiveEnergy) / Float(netCalorieGoal) < 0.0 {
            netProgressBar.progress = 1.0
            netProgressBar.progressTintColor = .red
            netProgressBar.setProgress(netProgressBar.progress, animated: true)
        }

    }
    
    //MARK: - Timer Action
    @objc func timerAction(_ timer: Timer) {
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthKit.isHealthKitAvailable()
        healthKit.getHealthKitPermission()
        
        updateLabels()
        
        meditationProgressBar.progress = 0.0
        meditationProgressBar.transform = meditationProgressBar.transform.scaledBy(x:1, y: 5)
        meditationProgressBar.layer.cornerRadius = 10
        meditationProgressBar.clipsToBounds = true
        meditationProgressBar.layer.sublayers![1].cornerRadius = 10
        meditationProgressBar.subviews[1].clipsToBounds = true

        sleepProgressBar.progress = 0.0
        sleepProgressBar.transform = sleepProgressBar.transform.scaledBy(x:1, y: 5)
        sleepProgressBar.layer.cornerRadius = 10
        sleepProgressBar.clipsToBounds = true
        sleepProgressBar.layer.sublayers![1].cornerRadius = 10
        sleepProgressBar.subviews[1].clipsToBounds = true

        activityProgressBar.progress = 0.0
        activityProgressBar.transform = activityProgressBar.transform.scaledBy(x:1, y: 5)
        activityProgressBar.layer.cornerRadius = 10
        activityProgressBar.clipsToBounds = true
        activityProgressBar.layer.sublayers![1].cornerRadius = 10
        activityProgressBar.subviews[1].clipsToBounds = true

        dietaryProgressBar.progress = 0.0
        dietaryProgressBar.transform = dietaryProgressBar.transform.scaledBy(x:1, y: 5)
        dietaryProgressBar.layer.cornerRadius = 10
        dietaryProgressBar.clipsToBounds = true
        dietaryProgressBar.layer.sublayers![1].cornerRadius = 10
        dietaryProgressBar.subviews[1].clipsToBounds = true

        netProgressBar.progress = 0.0
        netProgressBar.transform = netProgressBar.transform.scaledBy(x:1, y: 5)
        netProgressBar.layer.cornerRadius = 10
        netProgressBar.clipsToBounds = true
        netProgressBar.layer.sublayers![1].cornerRadius = 10
        netProgressBar.subviews[1].clipsToBounds = true

    }


}

