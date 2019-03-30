//
//  SetGoalDurationController.swift
//  urComp
//
//  Created by spoonik on 2018/10/23.
//  Copyright © 2018年 spoonikapps. All rights reserved.
//

import WatchKit
import Foundation

protocol NotifyDurationSetting {
	func notifyDurationSetted()
}

class SetGoalDurationController: WKInterfaceController {

    @IBOutlet var valueCategory: WKInterfaceLabel!
    @IBOutlet var picker: WKInterfacePicker!
  
	var category: Int = 0
    let sliderMax: Int = 120   //StoryBoardの設定を合わせること！
    
    var maxPickerValue: Int = 120
    var currentPickerValue: Int = 10
    var selectedPickerValue: Int = 0
    var delegate: NotifyDurationSetting? = nil
  
    let categoryStrings = ["Mindfulness", "Exercise", "Workout"]
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        (category, currentPickerValue, delegate) = context as! (Int, Int, NotifyDurationSetting?)
		valueCategory.setText(categoryStrings[category-1])
        
        var pickerItems: [WKPickerItem] = []
        for i in 0...60 {
            let pickerItem = WKPickerItem()
            pickerItem.title = String(i)
            pickerItems.append(pickerItem)
        }
        picker.setItems(pickerItems)
        picker.setSelectedItemIndex(currentPickerValue)
        picker.focus()
    }

    @IBAction func pickerValueChanged(_ value: Int) {
        currentPickerValue = value
    }
  
    @IBAction func pushSet() {
        switch category {
        case 1:
            UserDefaults.standard.set(Float(currentPickerValue), forKey: "mindfulGoalDuration")
        case 2:
            UserDefaults.standard.set(Float(currentPickerValue), forKey: "lightExGoalDuration")
        case 3:
            UserDefaults.standard.set(Float(currentPickerValue), forKey: "workoutGoalDuration")
        default:
            return
        }
        UserDefaults.standard.synchronize()
        delegate!.notifyDurationSetted()
        self.dismiss()
    }

    override func willActivate() {
        super.willActivate()
    }
}
