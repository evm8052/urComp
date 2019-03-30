//
//  Data.swift
//  ComplicateAppBuilders
//
//  Created by Vasile Cotovanu on 07/07/15.
//  Copyright © 2015 Vasile Cotovanu. All rights reserved.
//
import Foundation
import HealthKit

protocol HealthDataCallback {
    func healthDataUpdated(summary: Float, mindfulTime: Float, lightExTime: Float, workoutTime: Float)
}

class HealthData {
    let healthStore = HKHealthStore()
    var workoutTime: TimeInterval = 0.0
    var lightExcerciseTime: TimeInterval = 0.0
    var mindfulTime: TimeInterval = 0.0
    
    // 取得する期間を設定
    var startDate: Date = Calendar(identifier: .gregorian).startOfDay(for: Date())
    var endDate: Date = Date()
    
    // Singleton Pattern
    static let sharedManager: HealthData = {
        let instance = HealthData()
        return instance
    }()
    
    fileprivate init() {
    }
    
    func refreshCompletionPercentage(delegate: HealthDataCallback?) {
        startDate = Calendar(identifier: .gregorian).startOfDay(for: Date())
        endDate = Date()
        activateHealthKit()
        refreshWorkoutAndMindfulnessDuration(delegate: delegate)
    }
    
    func activateHealthKit() {
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!,
            HKWorkoutType.workoutType()
            ])
        self.healthStore.requestAuthorization(toShare: nil, read: typestoShare) { (success, error) -> Void in
            if success == true {
                NSLog("Integrated SuccessFully")
            }
            else {
                NSLog("Display not allowed")
            }
        }
    }
    
    func refreshWorkoutAndMindfulnessDuration(delegate: HealthDataCallback?) {
        // 取得するデータを設定
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sort = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
        let q = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: sort, resultsHandler:{
            (query, result, error) in
            
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                guard let r = result else {
                    return
                }
                
                let workouts = r as! [HKWorkout]
                self.workoutTime = 0.0
                self.lightExcerciseTime = 0.0
                for workout in workouts {
                    if SettingsManager.sharedManager.getLightExcerciseSetting().contains(workout.workoutActivityType)  {
                        self.lightExcerciseTime = self.lightExcerciseTime + workout.duration
                    } else {
                        self.workoutTime = self.workoutTime + workout.duration
                    }
                }
                //self.button.setTitle(String(duration), for: UIControl.State.normal)
                self.workoutTime = self.workoutTime / 60.0   //Minutes
                self.lightExcerciseTime = self.lightExcerciseTime / 60.0
                
                // 非同期なので、ここで次のデータ取得を予約する
                self.refreshMindfulnessDuration(delegate: delegate)
            }
        })
        
        healthStore.execute(q)
    }
    
    func refreshMindfulnessDuration(delegate: HealthDataCallback?) {
        // 取得するデータを設定
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sort = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
        let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
        let q = HKSampleQuery(sampleType: mindfulType!, predicate: predicate, limit: 0, sortDescriptors: sort, resultsHandler:{
            (query, result, error) in
            
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                guard let r = result else {
                    return
                }
                
                let workouts = r //as! [HKSample]
                var duration: TimeInterval = 0.0
                for workout in workouts {
                    duration = duration + workout.endDate.timeIntervalSince(workout.startDate)
                }
                //self.mindfulButton.setTitle(String(duration), for: UIControl.State.normal)
                self.mindfulTime = duration / 60.0   //Minutes
                
                // 非同期なので、最終的なデータの計算結果の処理を予約する
                self.summarizeAllExcerciseDurationToAchievementValue(delegate: delegate)
            }
        })
        
        healthStore.execute(q)
    }
    
    func summarizeAllExcerciseDurationToAchievementValue(delegate: HealthDataCallback?) {
        let (mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration) = SettingsManager.sharedManager.getDurationGoalsSetting()
        
        var (mindfulGoalWeight, lightExGoalWeight, workoutGoalWeight) = SettingsManager.sharedManager.getEachExcerciseWeight()
        let totalWeight = mindfulGoalWeight + lightExGoalWeight + workoutGoalWeight
        mindfulGoalWeight = mindfulGoalWeight / totalWeight
        lightExGoalWeight = lightExGoalWeight / totalWeight
        workoutGoalWeight = workoutGoalWeight / totalWeight
        
        let totalPercentage: Float = (Float(mindfulTime) / Float(mindfulGoalDuration)) * mindfulGoalWeight
            + ((lightExGoalDuration > 0) ? (Float(lightExcerciseTime) / Float(lightExGoalDuration)) * lightExGoalWeight : 0.0)
            + ((workoutGoalDuration > 0) ? (Float(workoutTime) / Float(workoutGoalDuration)) * workoutGoalWeight : 0.0)
        
        SettingsManager.sharedManager.setCurrentTimeStatus(mindfulCurrentTime: Float(mindfulTime), lightExCurrentTime: Float(lightExcerciseTime), workoutCurrentTime: Float(workoutTime))
        
        //値をUserDefaultに書き込んでからDelegateにリロードしてもらう
        if totalPercentage != SettingsManager.sharedManager.getComplicationValue() {
            SettingsManager.sharedManager.setNewComplicationValueFlag(result: true)
            SettingsManager.sharedManager.setComplicationValue(result: totalPercentage)
        }
        
        if delegate != nil {
            delegate!.healthDataUpdated(summary: totalPercentage, mindfulTime: Float(mindfulTime), lightExTime: Float(lightExcerciseTime), workoutTime: Float(workoutTime))
        }
        
        //reloadComplications()
    }
}

