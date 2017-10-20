//
//  SettingDatepicker.swift
//  BookApp
//
//  Created by kien le van on 9/27/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SettingDatepicker: BaseDailog {

    @IBOutlet weak var datepicker: UIDatePicker!
    var callBackDate:((_ date: String) -> Void) = {_ in}
    
    static func getView() -> SettingDatepicker {
        let view = Bundle.main.loadNibNamed("SettingDatepicker", owner: self, options: nil)?.first as? SettingDatepicker
        return view!
    }

    @IBAction func pressedOk(_ sender: Any) {
        let date = Date.showDateString(date: datepicker.date)
        self.hide()
        self.callBackDate(date)
    }
}

extension Date {
    static func showDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateSting = dateFormatter.string(from: date)
        return dateSting
    }
}
