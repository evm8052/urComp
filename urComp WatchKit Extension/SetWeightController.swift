//
//  SetWeightsInterfaceController.swift
//  urComp
//
//  Created by spoonik on 2018/10/23.
//  Copyright © 2018年 spoonikapps. All rights reserved.
//

import WatchKit
import Foundation


class SetWeightsInterfaceController : WKInterfaceController {

	@IBOutlet weak var buttonMindful: WKInterfaceButton!
	@IBOutlet weak var buttonLightEx: WKInterfaceButton!
	@IBOutlet weak var buttonWorkout: WKInterfaceButton!
	
    @IBOutlet weak var mindfulLabel: WKInterfaceLabel!
    @IBOutlet weak var lightExLabel: WKInterfaceLabel!
    @IBOutlet weak var workoutLabel: WKInterfaceLabel!

	@IBOutlet weak var buttonGraphMindful: WKInterfaceButton!
	@IBOutlet weak var buttonGraphLightEx: WKInterfaceButton!
	@IBOutlet weak var buttonGraphWorkout: WKInterfaceButton!
    
    @IBOutlet weak var imgMindful: WKInterfaceImage!
    @IBOutlet weak var imgLightEx: WKInterfaceImage!
    @IBOutlet weak var imgWorkout: WKInterfaceImage!
    
    
    @IBOutlet var picker: WKInterfacePicker!
    
    let unselectedColor = [
        UIColor(red: 0.082, green: 0.722, blue: 0.612, alpha: 0.5),
        UIColor(red: 0.026, green: 0.974, blue: 0.014, alpha: 0.5),
        UIColor(red: 0.953, green: 0.555, blue: 0.094, alpha: 0.5)]
    
	
	var mindfulSelected = true
	var lightExSelected = false
	var workoutSelected = false
	
    var delegate: NotifyDurationSetting? = nil
    
	let (mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration) = SettingsManager.sharedManager.getDurationGoalsSetting()
	var (mindfulGoalWeight, lightExGoalWeight, workoutGoalWeight) = SettingsManager.sharedManager.getEachExcerciseWeight()

    var currentSelectedCategory = 0
    var currentValue: Float = 0.0

    override func willActivate() {
        super.willActivate()
        
        var pickerItems: [WKPickerItem] = []
        for i in 0...100 {
            let pickerItem = WKPickerItem()
            pickerItem.title = String(i)
            pickerItems.append(pickerItem)
        }
        picker.setItems(pickerItems)

        //init graph images
        let bgimg = UIImage(named:"rect.png")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //let bgimg = UIImage()  (contentsOfFile: "rect.png")
        
        //imageWithRenderingMode: method on an existing UIImage and specify the UIImageRenderingModeAlwaysTemplate
        
        imgMindful.setImage(bgimg)
        imgLightEx.setImage(bgimg)
        imgWorkout.setImage(bgimg)

        /*
         imgMindful.withRenderingMode(.alwaysTemplate)
         imgLightEx.withRenderingMode(.alwaysTemplate)
         imgWorkout.withRenderingMode(.alwaysTemplate)
         */

        updateLabelAndGraph()

        //とりあえずMindfulnessを選択した状態にする
        changeSelectedState(pushedButton: 1)
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		//delegate = context as! NotifyWeightsSetting
        
        delegate = context as? NotifyDurationSetting
	}
	
	func refreshScreen() {
		mindfulLabel.setHidden(!mindfulSelected)
		lightExLabel.setHidden(!lightExSelected)
		workoutLabel.setHidden(!workoutSelected)
	}
	
	func changeSelectedState(pushedButton: Int) {
		currentSelectedCategory = pushedButton
		switch pushedButton {
		case 1:
			mindfulSelected = true
			lightExSelected = false
			workoutSelected = false
		case 2:
			mindfulSelected = false
			lightExSelected = true
			workoutSelected = false
		case 3:
			mindfulSelected = false
			lightExSelected = false
			workoutSelected = true
		default:
			mindfulSelected = true
			lightExSelected = false
			workoutSelected = false
			currentSelectedCategory = 0
		}
        setupPickerForSelectedCategory()
		refreshScreen()
	}
	
    @IBAction func pushMindfulButton() {
		changeSelectedState(pushedButton: 1)
	}
    @IBAction func pushLightExButton() {
		changeSelectedState(pushedButton: 2)
	}
    @IBAction func pushWorkoutButton() {
		changeSelectedState(pushedButton: 3)
	}
    @IBAction func pushSet() {
		SettingsManager.sharedManager.setEachExcerciseWeight(
			mindfulGoalWeight: mindfulGoalWeight, 
			lightExGoalWeight: lightExGoalWeight, 
			workoutGoalWeight: workoutGoalWeight)
        delegate!.notifyDurationSetted()
        self.dismiss()
    }

	func getSelectedCategoryValue() -> Float{
		switch currentSelectedCategory {
		case 1:
			currentValue = mindfulGoalWeight
		case 2:
			currentValue = lightExGoalWeight
		case 3:
			currentValue = workoutGoalWeight
		default:
			currentValue = 0.0
		}
		return currentValue
	}
	func setSelectedCategoryValue(value: Float) {
		switch currentSelectedCategory {
		case 1:
			mindfulGoalWeight = value
			(lightExGoalWeight, workoutGoalWeight) = calculateAdjustedWeightValues(prioritizedValue: value, originalValue1: lightExGoalWeight, originalValue2: workoutGoalWeight)
		case 2:
			lightExGoalWeight = value
			(mindfulGoalWeight, workoutGoalWeight) = calculateAdjustedWeightValues(prioritizedValue: value, originalValue1: mindfulGoalWeight, originalValue2: workoutGoalWeight)
		case 3:
			workoutGoalWeight = value
			(mindfulGoalWeight, lightExGoalWeight) = calculateAdjustedWeightValues(prioritizedValue: value, originalValue1: mindfulGoalWeight, originalValue2: lightExGoalWeight)
		default:
			currentValue = 0.0
			return
		}
		updateLabelAndGraph()
	}
	func calculateAdjustedWeightValues(prioritizedValue: Float, originalValue1: Float, originalValue2: Float) -> (Float, Float) {
		let remain = 1.0 - prioritizedValue
        if (originalValue1 + originalValue2) < 0.001 {
            return (0, 0)
        }
		return (remain * originalValue1 / (originalValue1 + originalValue2), 
					remain * originalValue2 / (originalValue1 + originalValue2))
	}
	
	func setupPickerForSelectedCategory() {
		let value = Int(getSelectedCategoryValue() * 100.0)
        picker.setSelectedItemIndex(value)
        picker.focus()
	}
	
    @IBAction func pickerValueChanged(_ value: Int) {
        let fvalue = Float(value) / 100.0
		setSelectedCategoryValue(value: fvalue)
    }
	
	func updateLabelAndGraph() {
		updateLabels()
        refreshScreen()
		updateGraph()
	}
	func updateLabels() {
        mindfulLabel.setText(String(format: "%dmin = %d%%", mindfulGoalDuration, Int(mindfulGoalWeight*100.0)))
        lightExLabel.setText(String(format: "%dmin = %d%%", lightExGoalDuration, Int(lightExGoalWeight*100.0)))
        workoutLabel.setText(String(format:"%dmin = %d%%", workoutGoalDuration, Int(workoutGoalWeight*100.0)))
	}
    func updateGraph() {
        imgMindful.setTintColor(currentSelectedCategory == 1 ? categoryUIColors[0] : unselectedColor[0])
        imgLightEx.setTintColor(currentSelectedCategory == 2 ? categoryUIColors[1] : unselectedColor[1])
        imgWorkout.setTintColor(currentSelectedCategory == 3 ? categoryUIColors[2] : unselectedColor[2])
        
        imgMindful.setRelativeWidth(CGFloat(mindfulGoalWeight), withAdjustment: 0.0)
        imgLightEx.setRelativeWidth(CGFloat(lightExGoalWeight), withAdjustment: 0.0)
        imgWorkout.setRelativeWidth(CGFloat(workoutGoalWeight), withAdjustment: 0.0)
	}
}
