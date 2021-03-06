//

import UIKit
import HealthKit

class HealthKit {
    
    var userWeightInPounds : Double = 0.0
    var userWeightInKilo : Double = 0.0
    var userAge : Int = 0
    var userDietaryEnergy : Double = 0.0
    var userActiveEnergy : Double = 0.0
    var userBasalEnergy : Double = 0.0
    var userStepCount : Double = 0.0
    var userMindfulMinutes : Double = 0.0
    var userSleepHours : Double = 0.0
    var savedMeditation : Bool = true

    
    //MARK: - Steps to access the Apple Health App Data.
    //1. Enable HealthKit for the target in [Signing & Capabilities].  To add the capacity select the "+" and choose HealthKit.
    
    //2. Ensure HealthKit's Available
    func isHealthKitAvailable () {
        if HKHealthStore.isHealthDataAvailable() {
            print("Apple Health Store is available.")
        }
    }
    
    //3. Create the HealthKit Store
    let healthKit = HKHealthStore()

    //4. Authorizing Access to Health Data
    func getHealthKitPermission() {
            let sampleTypesToWrite: Set<HKSampleType> = [.workoutType(),
                                                         HKSampleType.quantityType(forIdentifier: .heartRate)!,
                                                         HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                                         HKSampleType.quantityType(forIdentifier: .distanceCycling)!,
                                                         HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!]

            // changed Set<> to super class HKObjectType from HKSampleType to allow both quantityTypes and characteristicTypes
            let sampleTypesToRead: Set<HKObjectType> = [.workoutType(),
                                                        HKSampleType.quantityType(forIdentifier: .heartRate)!,
                                                        HKSampleType.quantityType(forIdentifier: .restingHeartRate)!,
                                                        HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
                                                        HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
                                                        HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!,
                                                        HKSampleType.quantityType(forIdentifier: .distanceCycling)!,
                                                        HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                                        HKSampleType.quantityType(forIdentifier: .flightsClimbed)!,
                                                        HKSampleType.quantityType(forIdentifier: .stepCount)!,
                                                        HKSampleType.quantityType(forIdentifier: .bodyMass)!,
                                                        HKSampleType.quantityType(forIdentifier: .leanBodyMass)!,
                                                        HKSampleType.quantityType(forIdentifier: .height)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryProtein)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryFatTotal)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryFatSaturated)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryCholesterol)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietarySugar)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietaryFiber)!,
                                                        HKSampleType.quantityType(forIdentifier: .dietarySodium)!,
                                                        HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!,
                                                        HKSampleType.categoryType(forIdentifier: .mindfulSession)!,
                                                        HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!,
                                                        HKSampleType.characteristicType(forIdentifier: .dateOfBirth)!]
            
            //Check authorization from Healthkit and if it exists, let the user know.  If the check fails, let the user know.
            healthKit.requestAuthorization(toShare: sampleTypesToWrite, read: sampleTypesToRead) { (success, error) in
                if success {
                    print("Permissions Approved!")
                } else {
                    if error != nil {
                        print(error ?? "")
                    }
                    print("Permissions Denied!")
                }
            }
        
        getWeight()
        }

        //5. Chect for Authorization Before Saving Data
    func isHealthKitAuthorized() {
        healthKit.authorizationStatus(for: .activitySummaryType())
        healthKit.authorizationStatus(for: .workoutType())
    }
    
        //6. Add the following Key | Values to the info.plist
        //   Privacy - Health Share Usage Descriptin > type information why your app needs to read health data.
        //   Privacy - Health Update Usage Description > type information why your app needs to write health data.
// ---------------------------------------------------------------------------------------------------------------------------------//
    
        //MARK: - Get Weight
        func getWeight() {
            guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
                print("Weight Sample Type is no longer available in HealthKit")
                return
            }
            
            self.getMostRecentSample(for: weightSampleType, completion: { (sample, error) in
                guard let sample = sample else {
                    return
                }

                self.userWeightInKilo = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                self.userWeightInPounds = sample.quantity.doubleValue(for: HKUnit.pound())
            })
        }

        //MARK: - Get Age
        func getAge() throws -> (Int) {
            
            do {
                //1. This method throws an error if this data is not available.
                let birthdayComponents =  try healthKit.dateOfBirthComponents()
                
                //2. Use Calendar to calculate age.
                let today = Date()
                let calendar = Calendar.current
                let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: today)
                let yearDifference = todayDateComponents.year! - birthdayComponents.year!
                
                if todayDateComponents.month! <= birthdayComponents.month!{
                    userAge = yearDifference - 1
                    
                    if todayDateComponents.month! <= birthdayComponents.month! {
                        
                        if todayDateComponents.day! < birthdayComponents.day! {
                        } else {
                        }
                    }
                } else {
                    userAge = yearDifference
                }
                return (userAge)
            }
        }
    
        //MARK: - Get Most Recent Sample
        //A query to get the most recent sample for whatever you would like to retreive
        func getMostRecentSample(for sampleType: HKSampleType,
                                 completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
            
            //1. Use HKQuery to load the most recent samples.
            let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                                  end: Date(),
                                                                  options: .strictEndDate)
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                                  ascending: false)
            
            let limit = 1
            
            let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                
                //2. Always dispatch to the main thread when complete.
                DispatchQueue.main.async {
                    
                    guard let samples = samples,
                        let mostRecentSample = samples.first as? HKQuantitySample else {
                            
                            completion(nil, error)
                            return
                    }
                    completion(mostRecentSample, nil)
                }
            }
            HKHealthStore().execute(sampleQuery)
        }
    
    //MARK: - Get Todays Steps
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
         
         let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
         
         let now = Date()
         let startOfDay = Calendar.current.startOfDay(for: now)
         let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
         
         let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
             var resultCount = 0.0
             guard let result = result else {
                 print("Failed to fetch steps rate")
                 completion(resultCount)
                 return
             }
             if let sum = result.sumQuantity() {
                 resultCount = sum.doubleValue(for: HKUnit.count())
             }
             
             DispatchQueue.main.async {
                print("resultCount - \(resultCount)")
                self.userStepCount = resultCount
                completion(resultCount)
             }
         }
         healthKit.execute(query)
     }
     
    //MARK: - Convert query start and end dates
    func convertStartDate(StartDate: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd '00':'00':'01' +0000"
        let dateString = dateFormatter.string(from: StartDate)
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss +0000"
        let date = dateFormatter.date(from: dateString)

        return date!
    }
    
    func convertEndDate(EndDate: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd '23':'59':'59' +0000"
        let dateString = dateFormatter.string(from: EndDate)
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss +0000"
        let date = dateFormatter.date(from: dateString)

        return date!
    }

    //MARK: - Convert sleep query start and end dates
    func convertSleepStartDate(StartDate: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd '18':'00':'01' +0000"
        let dateString = dateFormatter.string(from: StartDate)
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss +0000"
        let date = dateFormatter.date(from: dateString)
        let datePrior = Calendar.current.date(byAdding: .hour, value: -24, to: date!)

        return datePrior!
    }
    
    func convertSleepEndDate(EndDate: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd '17':'59':'59' +0000"
        let dateString = dateFormatter.string(from: EndDate)
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss +0000"
        let date = dateFormatter.date(from: dateString)

        return date!
    }
    //MARK: - Read Dietary Energy
    func readDietaryEnergy(date: Date) {
        guard let energyType = HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Sample type not available")
            return
        }
        
        let startDate = convertStartDate(StartDate: date)
        let endDate = convertEndDate(EndDate: date)
        let Predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let dietaryEnergyQuery = HKSampleQuery(sampleType: energyType,
                                        predicate: Predicate,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: nil) {
                                            (query, sample, error) in
                                            
                                            guard
                                                error == nil,
                                                let quantitySamples = sample as? [HKQuantitySample] else {
                                                    print("Something went wrong: \(String(describing: error))")
                                                    return
                                                    }
                                            
                                            let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
                                            DispatchQueue.main.async {
                                                self.userDietaryEnergy = total
                                                }
        }
        HKHealthStore().execute(dietaryEnergyQuery)

    }
     
    //MARK: - Read Active Energy
    func readActiveEnergy(date: Date) {
        guard let activeEnergy = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Sample type not available")
            return
        }
        
        let startDate = convertStartDate(StartDate: date)
        let endDate = convertEndDate(EndDate: date)
        let Predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let activeEnergyQuery = HKSampleQuery(sampleType: activeEnergy,
                                       predicate: Predicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) {
                                        (query, samples, error) in
                                        
                                        guard
                                            error == nil,
                                            let quantitySamples = samples as? [HKQuantitySample] else {
                                                print("Something went wrong: \(String(describing: error))")
                                                return
                                        }
                                        
                                        let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
                                        DispatchQueue.main.async {
                                            self.userActiveEnergy = total
                                        }
        }
        HKHealthStore().execute(activeEnergyQuery)
    }

    //MARK: - Read Basal Energy
    func readBasalEnergy(date: Date) {
        guard let basalEnergy = HKSampleType.quantityType(forIdentifier: .basalEnergyBurned) else {
            print("Sample type not available")
            return
        }
        
        let startDate = convertStartDate(StartDate: date)
        let endDate = convertEndDate(EndDate: date)
        let Predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let activeEnergyQuery = HKSampleQuery(sampleType: basalEnergy,
                                       predicate: Predicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) {
                                        (query, samples, error) in
                                        
                                        guard
                                            error == nil,
                                            let quantitySamples = samples as? [HKQuantitySample] else {
                                                print("Something went wrong: \(String(describing: error))")
                                                return
                                        }
                                        
                                        let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
                                        DispatchQueue.main.async {
                                            self.userBasalEnergy = total
                                        }
        }
        HKHealthStore().execute(activeEnergyQuery)
    }
    
    //MARK: - Read Mindful Minutes
    func readMindfulMinutes(date: Date) {
        
        guard let mindfulMinutes = HKSampleType.categoryType(forIdentifier: .mindfulSession) else {
            print("Sample type not available")
            return
        }
        
        let startDate = convertStartDate(StartDate: date)
        let endDate = convertEndDate(EndDate: date)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let mindfulMinutesQuery = HKSampleQuery(sampleType: mindfulMinutes,
                                                predicate: predicate,
                                                limit: HKObjectQueryNoLimit,
                                                sortDescriptors: nil) {
                                                    (query, samples, error) in
                                            
                                        guard
                                            error == nil,
                                        samples == samples as? [HKCategorySample] else {
                                                print("Something went wrong getting mindful minutes: \(String(describing: error))")
                                                return
                                        }
                                        
                                        let total = samples?.map(self.calculateMindfulMinutes).reduce(0, {$0 + $1}) ?? 0
                                        DispatchQueue.main.async {
                                            self.userMindfulMinutes = total
                                            print("userMindfulMinutes = \(self.userMindfulMinutes)")
                                        }
        
        }
        HKHealthStore().execute(mindfulMinutesQuery)
    }
    
    func calculateMindfulMinutes(sample: HKSample) -> TimeInterval {
        
        let minutes = sample.endDate.timeIntervalSince(sample.startDate) / 60

        return minutes
    }
    
    //MARK: - Save Mindful Minutes
    func saveMindfulMinutes(from: Date, amount: TimeInterval) {
        
        if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            let mindfulSample = HKCategorySample(type: mindfulType, value: HKCategoryValue.notApplicable.rawValue, start: Date(), end: Date() + amount)
            
            healthKit.save(mindfulSample) { (success, error) -> Void in
                if error != nil {
                    print("Something happened while saving mindful minutes")
                    self.savedMeditation = false
                    return
                }
                if success {
                    print("Meditation was saved to HealthKit")
                    self.savedMeditation = true
                } else {
                    print("Something happened while saving mindful minutes")
                    self.savedMeditation = false
                }
            }
        }
        
    }

        //MARK: - Read Sleep Analysis
        func readSleepAnalysis(date: Date) {

            if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
         
                let startDate = convertSleepStartDate(StartDate: date)
                let endDate = convertSleepEndDate(EndDate: date)
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    //            let asleepPredicate = HKQuery.predicateForObjects(from: HKObjectType.categoryType(forIdentifier: HKCategoryValueSleepAnalysis.asleep))
    //            let queryPredicate = NSCompoundPredicate(notPredicateWithSubpredicate: predicate, asleepPredicate)
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
         
                let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) {
                                                            (query, samples, error) in
                                                    
                                                guard
                                                    error == nil,
                                                samples == samples as? [HKCategorySample] else {
                                                        print("Something went wrong getting sleep analysis: \(String(describing: error))")
                                                        return
                                                }
                                                
                                                let total = samples?.map(self.calculateSleepHours).reduce(0, {$0 + $1}) ?? 0
                                                DispatchQueue.main.async {
                                                    self.userSleepHours = total
                                                }
                
                }
                healthKit.execute(query)
            }
        }

    func calculateSleepHours(sample: HKSample) -> TimeInterval {
        
        let hours = sample.endDate.timeIntervalSince(sample.startDate) / 60 / 60

        return hours
    }

     

//MARK: - End of code  

}
