

import UIKit


enum SleepTimerState {
case inactive
case active
case paused
}

class SleepViewController: UIViewController {
    
    var sleepInterval = 0.0
    var startDate = Date()
    var session = Session()
    var timerState = TimerState.inactive
    var sleepTimer = Timer()
    var time = 0
    var interval = 0
    var sleepTime = 0
    var duration : String = ""
    var sleepStart = Date()
    var sleepEnd = Date()
    var timer = Timer()
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var paused: UIButton!

    @IBAction func startButton(_ sender: UIButton) {
        startButtonPressed()
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
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
            startDate = Date().addingTimeInterval(-sleepInterval)
        }
        timerState = .active
        
        start.isHidden = true
        paused.isHidden = false
        
        updateTimerLabel()
        _foregroundTimer(repeated: true)
    }
    
    //MARK: - Paused Button Pressed
    func pausedButtonPressed(){
        sleepInterval = floor(-startDate.timeIntervalSinceNow)
        timerState = .paused
        timer.invalidate()
        displayPauseAlert()
    }
    
    //MARK: - Pause Meditation
    func pauseSleep(){
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
                                          message: "Would you like to pause your sleep?",
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes",
                                          style: .default) { (action) in
                                            self.pauseSleep()
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
            
            let alert = UIAlertController(title: "FitTrax",
                                          message: "Do you want to save your sleep?",
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes",
                                          style: .default) { (action) in
                                            self.saveSleep()
            }
            
            let noAction = UIAlertAction(title: "No",
                                         style: .cancel) { (action) in
                                            self.cancelledAlert()
            }
       
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }

        //MARK: - Save Sleep Alert
        func saveAlert() {
            
                let alert = UIAlertController(title: "FitTrax",
                                              message: "Sleep saved to Apple's Health app. \n\n Sleep summary.",
                    preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "OK",
                                               style: .default) { (action) in
                                                self.sleepSessionReset()
                }
                
                alert.addAction(okayAction)
                present(alert, animated: true, completion: nil)
        }
        
        //MARK: - Sleep Cancelled Alert
        private func cancelledAlert() {
            
            let alert = UIAlertController(title: "FitTrax",
                                          message: "Sleep was not saved to Apple's Health app",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK",
                                           style: .default) { (action) in
                                            self.sleepSessionReset()
            }
            
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
        
        //MARK: - Workout Did Not Save Alert
        func didNotSaveAlert() {
            
            let alert = UIAlertController(title: "FitTrax",
                                          message: "******* ERROR ERROR ERROR ******* \nThere was a problem saving your sleep to Apple's Health App.  Please manually record this information to the Health App by opening the app.  Enter the following: ",
                preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK",
                                           style: .default) { (action) in
                                            self.sleepSessionReset()
            }
            
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }

        //MARK: - Workout Session Reset
        func sleepSessionReset() {
            
            session.end()
            session.clear()
            timer.invalidate()
            timerState = .inactive
            sleepTimer.invalidate()
            resetApp()

        }
        
        //MARK: - Save Sleep
        func saveSleep() {
                        
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
                        
            duration = String(format:"%02ih:%02im:%02is", hours, minutes, seconds)
                        
            sleepEnd = Date()
                        
            saveAlert()
        }
    
        func resetApp() {
            
            time = 0
            interval = 0
            sleepTime = 0

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
