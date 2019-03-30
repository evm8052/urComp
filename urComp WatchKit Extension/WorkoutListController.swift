
//
//  WorkoutSelectController.swift
//  txt.rdr WatchKit Extension
//
//  Created by spoonik on 2016/04/14.
//  Copyright © 2016年 spoonikapps. All rights reserved.
//

import WatchKit
import HealthKit
import Foundation

enum CategoryIndex: Int {
	case NoCategory = 0
	case Mindfulness
	case Exercise
	case Workout
}

class WorkoutSelectController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    var delegate: NotifyDurationSetting? = nil

    let workoutItems : [(String, HKWorkoutActivityType)] = [
			("Walking", HKWorkoutActivityType.walking),
			("Yoga", HKWorkoutActivityType.yoga),
			("Core Training", HKWorkoutActivityType.coreTraining),
			("Strength Training", HKWorkoutActivityType.traditionalStrengthTraining),
			("Step Training", HKWorkoutActivityType.stepTraining),
			("Stairs", HKWorkoutActivityType.stairs),
			("Running", HKWorkoutActivityType.running),
			("Cycling", HKWorkoutActivityType.cycling),
			("Rowing", HKWorkoutActivityType.rowing),
			("High Intensity Interval", HKWorkoutActivityType.highIntensityIntervalTraining),
			("Hiking", HKWorkoutActivityType.hiking),
			("Swimming", HKWorkoutActivityType.swimming),
			("Water Fitness", HKWorkoutActivityType.waterFitness)
		]
    var selectedWorkoutItems: [HKWorkoutActivityType] = []
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        delegate = context as? NotifyDurationSetting
		selectedWorkoutItems = SettingsManager.sharedManager.getLightExcerciseSetting()
    }
    override func willActivate() {
        super.willActivate()
        reloadTable()
    }

    func reloadTable() {
        table.setNumberOfRows(workoutItems.count, withRowType: "WorkoutTableRow")
        for index in 0..<workoutItems.count {
            let row = table.rowController(at: index) as! WorkoutTableRow
            row.label.setText(workoutItems[index].0)
        }
		updateTableCellColor()
    }
    func updateTableCellColor() {
        for index in 0..<workoutItems.count {
            let row = table.rowController(at: index) as! WorkoutTableRow
            row.groupBox.setBackgroundColor(
					selectedWorkoutItems.contains(workoutItems[index].1) ? categoryUIColors[1] : categoryUIColors[2] )
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		let selectedItem = workoutItems[rowIndex].1
		if selectedWorkoutItems.contains(selectedItem) {
            selectedWorkoutItems.remove(at: selectedWorkoutItems.index(of: selectedItem)!)
		} else {
			selectedWorkoutItems.append(selectedItem)
		}
		updateTableCellColor()
    }

    @IBAction func pushSet() {
        SettingsManager.sharedManager.setLightExcerciseSetting(value: selectedWorkoutItems)
        dismiss()
    }
    override func didDeactivate() {
        super.didDeactivate()
        if delegate != nil {
            delegate?.notifyDurationSetted()
        }
    }
}
