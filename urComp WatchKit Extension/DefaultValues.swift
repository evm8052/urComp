//
//  DefaultValues.swift
//  calmdown
//
//  Created by spoonik on 2018/10/21.
//  Copyright © 2018 spoonikapps. All rights reserved.
//

import Foundation
import HealthKit
import UIKit


// Default Values　デフォルト値の定義

let categoryUIColors = [
    UIColor(red: 0.082, green: 0.722, blue: 0.612, alpha: 1.0),
    UIColor(red: 0.026, green: 0.974, blue: 0.014, alpha: 1.0),
    UIColor(red: 0.953, green: 0.555, blue: 0.094, alpha: 1.0)]

//ワークアウトの種類の中で「軽い運動」に分類するもののインデックス
let lightExcerciseTypesDefault = [ HKWorkoutActivityType.walking,
                                   HKWorkoutActivityType.yoga,
                                   HKWorkoutActivityType.preparationAndRecovery,
                                   HKWorkoutActivityType.flexibility,
                                   HKWorkoutActivityType.mindAndBody ]

//各エクササイズの1日の時間の達成目標ゴール
var mindfulGoalDurationDefault: Int = 18   //Minutes
var lightExGoalDurationDefault: Int = 15
var workoutGoalDurationDefault: Int = 6

//各エクササイズの時間の重み付け
var mindfulGoalWeightDefault: Float = 0.4
var lightExGoalWeightDefault: Float = 0.2
var workoutGoalWeightDefault: Float = 0.4
