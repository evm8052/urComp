//
//  DataAndSettingManager.swift
//  calmdown WatchKit Extension
//
//  Created by spoonik on 2018/10/21.
//  Copyright © 2018 spoonikapps. All rights reserved.
//

import Foundation
import HealthKit
import WatchConnectivity


class SettingsManager: NSObject {
    // Singleton Pattern : BookManager.sharedManager でインスタンスを取得
    //let sharedManager = BookManager()
    static let sharedManager: SettingsManager = {
        let instance = SettingsManager()
        return instance
    }()
    
    fileprivate override init() {
        super.init()        
    }
    
    func setNewComplicationValueFlag(result: Bool) {
        UserDefaults.standard.set(result, forKey: "newComplicationValueFlag")
        UserDefaults.standard.synchronize()
    }
    func getNewComplicationValueFlag() -> Bool {
        if UserDefaults.standard.object(forKey: "newComplicationValueFlag") != nil {
            return UserDefaults.standard.bool(forKey: "newComplicationValueFlag")
        } else {
            return false
        }
    }
    
    func setComplicationValue(result: Float) {
        UserDefaults.standard.set(result, forKey: "currentCompletionPercentage")
        UserDefaults.standard.synchronize()
    }
    func getComplicationValue() -> Float {
        if UserDefaults.standard.object(forKey: "currentCompletionPercentage") != nil {
            return UserDefaults.standard.float(forKey: "currentCompletionPercentage")
        } else {
            return 0.0
        }
    }
    
    func setLightExcerciseSetting(value: [HKWorkoutActivityType]) {
        UserDefaults.standard.set(value, forKey: "lightExcerciseSetting")
        UserDefaults.standard.synchronize()
    }
    func getLightExcerciseSetting() -> [HKWorkoutActivityType] {
        var lightExcerciseTypes = lightExcerciseTypesDefault
        
        if UserDefaults.standard.object(forKey: "lightExcerciseSetting") != nil {
            lightExcerciseTypes = UserDefaults.standard.array(forKey: "lightExcerciseSetting") as! [HKWorkoutActivityType]
        }
        
        return lightExcerciseTypes
    }

    
    func setCurrentTimeStatus(mindfulCurrentTime: Float, lightExCurrentTime: Float, workoutCurrentTime: Float) {
        UserDefaults.standard.set(mindfulCurrentTime, forKey: "mindfulCurrentTime")
        UserDefaults.standard.set(lightExCurrentTime, forKey: "lightExCurrentTime")
        UserDefaults.standard.set(workoutCurrentTime, forKey: "workoutCurrentTime")
        UserDefaults.standard.synchronize()
    }
    func getCurrentTimeStatus() -> (Float, Float, Float) {
        var mindfulCurrentTime: Float = 0.0
        var lightExCurrentTime: Float = 0.0
        var workoutCurrentTime: Float = 0.0
        
        if UserDefaults.standard.object(forKey: "mindfulCurrentTime") != nil {
            mindfulCurrentTime = UserDefaults.standard.float(forKey: "mindfulCurrentTime")
        }
        if UserDefaults.standard.object(forKey: "lightExCurrentTime") != nil {
            lightExCurrentTime = UserDefaults.standard.float(forKey: "lightExCurrentTime")
        }
        if UserDefaults.standard.object(forKey: "workoutCurrentTime") != nil {
            workoutCurrentTime = UserDefaults.standard.float(forKey: "workoutCurrentTime")
        }
        return (mindfulCurrentTime, lightExCurrentTime, workoutCurrentTime)
    }
    
    
    func setDurationGoalsSetting(mindfulGoalDuration: Float, lightExGoalDuration: Float, workoutGoalDuration: Float) {
        UserDefaults.standard.set(mindfulGoalDuration, forKey: "mindfulGoalDuration")
        UserDefaults.standard.set(lightExGoalDuration, forKey: "lightExGoalDuration")
        UserDefaults.standard.set(workoutGoalDuration, forKey: "workoutGoalDuration")
        UserDefaults.standard.synchronize()
    }
    func getDurationGoalsSetting() -> (Int, Int, Int) {
        var mindfulGoalDuration = mindfulGoalDurationDefault   //Minutes
        var lightExGoalDuration = lightExGoalDurationDefault   //Minutes
        var workoutGoalDuration = workoutGoalDurationDefault
        
        
        if UserDefaults.standard.object(forKey: "mindfulGoalDuration") != nil {
            mindfulGoalDuration = UserDefaults.standard.integer(forKey: "mindfulGoalDuration")
        }
        if UserDefaults.standard.object(forKey: "lightExGoalDuration") != nil {
            lightExGoalDuration = UserDefaults.standard.integer(forKey: "lightExGoalDuration")
        }
        if UserDefaults.standard.object(forKey: "workoutGoalDuration") != nil {
            workoutGoalDuration = UserDefaults.standard.integer(forKey: "workoutGoalDuration")
        }
 
        return (mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration)
    }
    
    func setEachExcerciseWeight(mindfulGoalWeight: Float, lightExGoalWeight: Float, workoutGoalWeight: Float) {
        UserDefaults.standard.set(mindfulGoalWeight, forKey: "mindfulGoalWeight")
        UserDefaults.standard.set(lightExGoalWeight, forKey: "lightExGoalWeight")
        UserDefaults.standard.set(workoutGoalWeight, forKey: "workoutGoalWeight")
        UserDefaults.standard.synchronize()
    }
    func getEachExcerciseWeight() -> (Float, Float, Float) {
        var mindfulGoalWeight: Float = mindfulGoalWeightDefault
        var lightExGoalWeight: Float = lightExGoalWeightDefault
        var workoutGoalWeight: Float = workoutGoalWeightDefault
        
        
        if UserDefaults.standard.object(forKey: "mindfulGoalWeight") != nil {
            mindfulGoalWeight = UserDefaults.standard.float(forKey: "mindfulGoalWeight")
        }
        if UserDefaults.standard.object(forKey: "lightExGoalWeight") != nil {
            lightExGoalWeight = UserDefaults.standard.float(forKey: "lightExGoalWeight")
        }
        if UserDefaults.standard.object(forKey: "workoutGoalWeight") != nil {
            workoutGoalWeight = UserDefaults.standard.float(forKey: "workoutGoalWeight")
        }
        
        return (mindfulGoalWeight, lightExGoalWeight, workoutGoalWeight)
    }
    
    // Watch送信用の辞書を生成
    func createDictionaryPack() -> [String : Any] {
        var dict : [String : Any] = [:]
        
        let (mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration) = getDurationGoalsSetting()
        let (mindfulGoalWeight, lightExGoalWeight, workoutGoalWeight) = getEachExcerciseWeight()
        let lightExcerciseTypes = getLightExcerciseSetting()

        dict["mindfulGoalDuration"] = mindfulGoalDuration
        dict["lightExGoalDuration"] = lightExGoalDuration
        dict["workoutGoalDuration"] = workoutGoalDuration
        dict["mindfulGoalWeight"] = mindfulGoalWeight
        dict["lightExGoalWeight"] = lightExGoalWeight
        dict["workoutGoalWeight"] = workoutGoalWeight
        dict["lightExcerciseTypes"] = lightExcerciseTypes
        
        return dict
    }

    func saveReceivedDictionaryPack(dict: [String : Any]) {
        var mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration : Float
        var mindfulGoalWeight, lightExGoalWeight, workoutGoalWeight : Float
        let lightExcerciseTypes : [HKWorkoutActivityType]
        
        mindfulGoalDuration = dict["mindfulGoalDuration"] as! Float
        lightExGoalDuration = dict["lightExGoalDuration"] as! Float
        workoutGoalDuration = dict["workoutGoalDuration"] as! Float
        mindfulGoalWeight = dict["mindfulGoalWeight"] as! Float
        lightExGoalWeight = dict["lightExGoalWeight"] as! Float
        workoutGoalWeight = dict["workoutGoalWeight"] as! Float
        lightExcerciseTypes = dict["lightExcerciseTypes"] as! [HKWorkoutActivityType]
        
        setDurationGoalsSetting(mindfulGoalDuration: mindfulGoalDuration, lightExGoalDuration: lightExGoalDuration, workoutGoalDuration: workoutGoalDuration)
        setEachExcerciseWeight(mindfulGoalWeight: mindfulGoalWeight, lightExGoalWeight: lightExGoalWeight, workoutGoalWeight: workoutGoalWeight)
        setLightExcerciseSetting(value: lightExcerciseTypes)
    }
}
