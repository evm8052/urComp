//
//  InterfaceController.swift
//  urComp WatchKit Extension
//
//  Created by spoonik on 2018/10/18.
//  Copyright © 2018 spoonikapps. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, HealthDataCallback, NotifyDurationSetting {
    @IBOutlet weak var mindfulLabel: WKInterfaceLabel!
    @IBOutlet weak var lightExLabel: WKInterfaceLabel!
    @IBOutlet weak var workoutLabel: WKInterfaceLabel!
    @IBOutlet weak var updatedLabel: WKInterfaceLabel!
    @IBOutlet weak var ratioLabel: WKInterfaceLabel!
    
    var mindfulGoalDuration: Int = 10
    var lightExGoalDuration: Int = 10
    var workoutGoalDuration: Int = 10
    var mindfulGoalWeight: Float = 33.3
    var lightExGoalWeight: Float = 33.3
    var workoutGoalWeight: Float = 33.3
    
    func awakeWithContext(context: AnyObject?) {
        super.awake(withContext: context)
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        updatedLabel.setHidden(true)
        HealthData.sharedManager.refreshCompletionPercentage(delegate: self)
    }
    override func didDeactivate() {
        // remove InterfaceController as a dataSourceChangedDelegate
        // to prevent memory leaks
        //WatchSessionManager.sharedManager.removeDataSourceChangedDelegate(delegate: self)
        super.didDeactivate()
    }
    
    //delegate用のプロトコル
    func healthDataUpdated(summary: Float, mindfulTime: Float, lightExTime: Float, workoutTime: Float) {
        //Complicationをリロードするだけ
        //reloadComplications()  //HealthData側で呼んでいる
        
        (mindfulGoalDuration, lightExGoalDuration, workoutGoalDuration) = SettingsManager.sharedManager.getDurationGoalsSetting()
        (mindfulGoalWeight, lightExGoalWeight, workoutGoalWeight) = SettingsManager.sharedManager.getEachExcerciseWeight()
        
        mindfulLabel.setText(String(format: "%.1f / %d min", mindfulTime, mindfulGoalDuration))
        lightExLabel.setText(String(format: "%.1f / %d min", lightExTime, lightExGoalDuration))
        workoutLabel.setText(String(format: "%.1f / %d min", workoutTime, workoutGoalDuration))
        ratioLabel.setText(String(format: "%d : %d : %d", Int(mindfulGoalWeight*100.0), Int(lightExGoalWeight*100.0), Int(workoutGoalWeight*100.0)))

        updatedLabel.setHidden(false)
        
        reloadComplications()
    }
    
    
    @IBAction func pushMindfulButton() {
        let context: AnyObject = (1, mindfulGoalDuration, self) as AnyObject
        self.presentController(withName: "SetGoalDurationController", context: context)
    }
    @IBAction func pushLightExButton() {
        let context: AnyObject = (2, lightExGoalDuration, self) as AnyObject
        self.presentController(withName: "SetGoalDurationController", context: context)
    }
    @IBAction func pushWorkoutButton() {
        let context: AnyObject = (3, workoutGoalDuration, self) as AnyObject
        self.presentController(withName: "SetGoalDurationController", context: context)
    }
    
    @IBAction func pushWeightsButton() {
        let context: AnyObject = self
        self.presentController(withName: "SetWeightsInterfaceController", context: context)
    }
    
    @IBAction func pushExerciseSelectionButton() {
        let context: AnyObject = self
        self.presentController(withName: "WorkoutSelectController", context: context)
    }
    
    func notifyDurationSetted() {
        HealthData.sharedManager.refreshCompletionPercentage(delegate: self)
    }
}
