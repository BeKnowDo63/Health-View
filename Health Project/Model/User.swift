//

import UIKit
import HealthKit

class User: UIViewController {

    //MARK: - Class instances
    let healthKit = HealthKit()
    
    //MARK: - Variables and Constants
    var userAge : Int = 0
    var userWeightInPounds : Double = 0.0
    var userWeightInKilo : Double = 0.0
    var userActivityGoal : Double = 600.0
    var userDietaryGoal : Double = 1400.0
    var userNetCalorieGoal : Double = -750.0
    
    //MARK: - Get Age
    func loadGetAge(){
        
        do {
            let loadUserAge = try healthKit.getAge()
            userAge = loadUserAge
        } catch {
            self.displayAgeAlert()
        }
    }
    
    func checkWeightStatus () {
        if userWeightInKilo == 0 {
            self.displayWeightAlert()
        }
    }
    
    //MARK: - Display Age Alert
    private func displayAgeAlert() {
        
//        print("displayAgeAlert()")
        let alert = UIAlertController(title: "Health View",
                                      message: "Missing Information!!!!\n\nPlease enter your age in the Health app to continue.\n\nIt is needed to calculate your maximum heart rate.",
                                      preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK",
                                       style: .default) { (action) in
                                        print("Calling viewDidLoad()")
//                                        self.viewController.viewDidLoad()
                                        
        }
        
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Display Weight Alert
    private func displayWeightAlert() {
        
//        print("displayWeightAlert()")
        let alert = UIAlertController(title: "Health View",
                                      message: "Missing Information!!!!\n\nPlease enter your weight in the Health app to continue.\n\nIt is needed to calculate your workout's calories per hour.",
                                      preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK",
                                       style: .default) { (action) in
                                        print("Calling viewDidLoad()")
                                        
        }
        
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}
