//
//  ChordController.swift
//  wKeys WatchKit Extension
//
//  Created by spoonik on 2018/08/21.
//  Copyright © 2018年 spoonikapps. All rights reserved.
//

import WatchKit
import Foundation

class SetWeightsController: WKInterfaceController {
    @IBOutlet var picker: WKInterfacePicker!
    @IBOutlet var valueCategory: WKInterfaceLabel!

    let root_names = ResourceManager.getRootNames()
    let chord_names = ResourceManager.getChordStyleNames()
	var (mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration) = SettingsManager.sharedManager.getDurationGoalsSetting()

    var pickerItems: [WKPickerItem]! = []
  
    var current_value = 0
	var category = 0
	let max_duration = 120
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		category = context as! Int
		setCategoryTitle()
		setDefaultValue()
        initPickers()
    }

	func setCategoryTitle() {
		var title = ""
		switch category {
		case 1:
			title = "Mindfulness"
		case 2:
			title = "Light Workout"
		case 3:
			title = "Workout"
		default:
			title = "Error!"
		}
		valueCategory.setText(title)
	}
	
	func updateSetValue() {
		var title = ""
		switch category {
		case 1:
			mindfulGoalDuration = Float(current_value)
		case 2:
			lightExGoalDuration = Float(current_value)
		case 3:
			workoutGoalDuration = Float(current_value)
		default:
			//
		}
		SettingsManager.sharedManager.setDurationGoalsSetting(mindfulGoalDuration: mindfulGoalDuration, lightExGoalDuration: lightExGoalDuration, workoutGoalDuration: workoutGoalDuration)
	}

	func setDefaultValue() {
		var title = ""
		switch category {
		case 1:
			current_value = Int(mindfulGoalDuration)
		case 2:
			current_value = Int(lightExGoalDuration)
		case 3:
			current_value = Int(workoutGoalDuration)
		default:
			//
		}
		current_value = max(current_value, 0)
		current_value = min(current_value, max_duration)
	}
	
    func initPickers() {
        pickerItems = []
      
        for i in 0...120 {
            let pickerItem = WKPickerItem()
            pickerItem.title = String(i)
            pickerItems.append(pickerItem)
        }
        picker.setItems(pickerItems)
		picker.setSelectedItemIndex(current_value)
    }
  
    @IBAction func pickerChanged(_ value: Int) {
        current_value = value
    }
    @IBAction func pushSet() {
		self.dismiss()
	}

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
