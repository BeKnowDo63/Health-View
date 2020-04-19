
import UIKit

class WorkoutViewController: UIViewController {
    
    let activity = [["Archery","Bowling","Fencing","Gymnastics","Track and Field"],
                    ["American Football", "Australian Football", "Baseball", "Basketball", "Cricket", "Disc Sports", "Handball", "Hockey", "Lacrosse", "Rugby", "Soccer", "Softball", "Volleyball"],
                    ["Preparation and Recovery", "Flexibility", "Walking", "Running", "Wheelchair Walk Pace", "Wheelchair Run Pace", "Cycling", "Hand Cycling", "Core Training", "Elliptical","Functional Training", "Traditional Strength Training", "Cross Training", "Mixed Cardio", "High Intensity Interval Training", "Jump Rope", "Stair Climbing", "Stairs", "Step Training", "Fitness Gaming"],
                    ["Barre", "Dance", "Yoga", "Mind and  Body", "Pilates"],
                    ["Badminton", "Racquetball", "Squash", "Table Tennis", "Tennis"],
                    ["Climbing", "Equestrian Sports", "Fishing", "Golf", "Hiking", "Hunting", "Play"],
                    ["Cross Country Skiing", "Curling", "Downhill Skiing", "Snow Sports", "Snowboarding", "Skating Sports"],
                    ["Paddle Sports", "Rowing", "Sailing", "Surfing Sports", "Swimming", "Water Fitness", "Water Polo", "Water Sports"],
                    ["Boxing", "Kickboxing", "Martial Arts", "Tai Chi", "Wrestling"],
                    ["Other"]
    ]

    let activityGroup = ["Individual Sports", "Team Sports", "Exercise and Fitness", "Studio Activities", "Racket Sports","Outdoor Activities","Snow and Ice Sports", "Water Activities", "Martial Arts", "Other Activites"]
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activity.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activityGroup[section]
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
}

extension WorkoutViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activity[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = activity[indexPath.section][indexPath.row]
        
        return cell
    }
}


extension WorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row", indexPath.row)
    }
}
