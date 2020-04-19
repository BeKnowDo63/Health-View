
import UIKit


enum TimerState {
case inactive
case active
case paused
}

class MeditationViewController: UIViewController {
    
    let healthKit = HealthKit()
    var meditationInterval = 0.0
    var startDate = Date()
    var session = Session()
    var timerState = TimerState.inactive
    var meditationTimer = Timer()
    var time = 0
    var meditationTime = 0
    var duration : String = ""
    var meditationStart = Date()
    var meditationEnd = Date()
    var timer = Timer()
    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var paused: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func startButton(_ sender: UIButton) {
        startButtonPressed()
    }
    
    @IBAction func pausedButton(_ sender: UIButton) {
        pausedButtonPressed()
    }
    
    //MARK: - Update Timer Label
    func updateTimerLabel() {
        let interval = -Int(startDate.timeIntervalSinceNow)
        let hours = interval / 3600
        let minutes = interval / 60 % 60
        let seconds = interval % 60
        
        timerLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    //MARK: - Start Button Pressed
    func startButtonPressed() {
        
        if timerState == .inactive {
            startDate = Date()
        } else if timerState == .paused {
            startDate = Date().addingTimeInterval(-meditationInterval)
        }
        timerState = .active
        
        start.isHidden = true
        paused.isHidden = false
        
        updateTimerLabel()
        _foregroundTimer(repeated: true)
    }
    
    //MARK: - Paused Button Pressed
    func pausedButtonPressed(){
        meditationInterval = floor(-startDate.timeIntervalSinceNow)
        timerState = .paused
        timer.invalidate()
        displayPauseAlert()
    }
    
    //MARK: - Pause Meditation
    func pauseMeditation(){
        paused.isHidden = true
        start.isHidden = false
    }
    
    //MARK: - Timer Functions
    func _foregroundTimer(repeated: Bool) -> Void {
        
        //Define a Timer
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction(_:)), userInfo: nil, repeats: true);
    }
    
    @objc func timerAction(_ timer: Timer) {
        self.updateTimerLabel()
    }
    
    @objc func observerMethod(notification: NSNotification) {
        
        if notification.name == UIApplication.didEnterBackgroundNotification {
            
            // stop UI update
            timer.invalidate()
        } else if notification.name == UIApplication.didBecomeActiveNotification {
            
            if timerState == .active {
                updateTimerLabel()
                _foregroundTimer(repeated: true)
            }
        }
    }

        //MARK:  - Display Pause Alert
        private func displayPauseAlert() {
            
            let alert = UIAlertController(title: "FitTrax",
                                          message: "Would you like to pause the meditation?",
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes",
                                          style: .default) { (action) in
                                            self.pauseMeditation()
            }
            
            let noAction = UIAlertAction(title: "No",
                                         style: .cancel) { (action) in
                                            self.displaySaveAlert()
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }

        //MARK: - Display Save Alert
        private func displaySaveAlert() {
            
    //        print("displaySaveAlert()")
            let alert = UIAlertController(title: "FitTrax",
                                          message: "Do you want to save the meditation?",
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes",
                                          style: .default) { (action) in
                                            self.saveMeditation()
            }
            
            let noAction = UIAlertAction(title: "No",
                                         style: .cancel) { (action) in
                                            self.cancelledAlert()
            }
       
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }

        //MARK: - Save Meditation Alert
        func saveAlert() {
            
                let alert = UIAlertController(title: "FitTrax",
                                              message: "Meditation saved to Apple's Health app. \n\n Meditation summary.",
                    preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "OK",
                                               style: .default) { (action) in
                                                self.meditationSessionReset()
                }
                
                alert.addAction(okayAction)
                present(alert, animated: true, completion: nil)
        }
        
        //MARK: - Meditation Cancelled Alert
        private func cancelledAlert() {
            
    //        print("workoutCancelledAlert()")
            let alert = UIAlertController(title: "FitTrax",
                                          message: "Meditation was not saved to Apple's Health app",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK",
                                           style: .default) { (action) in
                                            self.meditationSessionReset()
            }
            
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
        
        //MARK: - Meditation Did Not Save Alert
        func didNotSaveAlert() {
            
            let alert = UIAlertController(title: "FitTrax",
                                          message: "******* ERROR ERROR ERROR ******* \nThere was a problem saving your meditation to Apple's Health App.  Please manually record this information to the Health App by opening the app.  Enter the following: ",
                preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK",
                                           style: .default) { (action) in
                                            self.meditationSessionReset()
            }
            
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }

        //MARK: - Meditation Session Reset
        func meditationSessionReset() {
            
            session.end()
            session.clear()
            timer.invalidate()
            timerState = .inactive
            meditationTimer.invalidate()
            resetApp()
        }
        
        //MARK: - Save Meditation
        func saveMeditation() {
                        
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
                        
            duration = String(format:"%02ih:%02im:%02is", hours, minutes, seconds)
                        
            meditationEnd = Date()
                        
            healthKit.saveMindfulMinutes(from: startDate, amount: meditationInterval)

                if healthKit.savedMeditation == true {

                    saveAlert()

                } else {

                    didNotSaveAlert()

                }
        }
    
        func resetApp() {
            
            time = 0
//            interval = 0
            meditationTime = 0

            timer.invalidate()
            
            start.isHidden = false
            paused.isHidden = true
            
            timerLabel.text = ""
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(observerMethod), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(observerMethod), name: UIApplication.didBecomeActiveNotification, object: nil)

        paused.isHidden = true
        start.isHidden = false
        
        timerLabel.text = ""
        
        timer.invalidate()
    }
//MARK: - End of Code
}
