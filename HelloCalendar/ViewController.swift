//
//  ViewController.swift
//  HelloCalendar
//
//  Created by chong chen on 2019/2/4.
//  Copyright © 2019 once. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! //  主要是这个，绑定到最大的日历view，上图中的紫色背景的view中
    
    @IBOutlet weak var year: UILabel! // 这两个是年和月代表的是日历上面的年月
    @IBOutlet weak var month: UILabel!
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue:0x4e3f5b)
    
    
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        // 1 configuration
        super.viewDidLoad()
        setupCalendarView()
        
        // 2 Setup labels
        calendarView.visibleDates{(visibleDates) in
            
        }
        
    }
    
    func setupCalendarView(){
        // 这两个如果不配置的话，会导致点击某一天的事情边距太大，里面显示不了，如下图
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    // 这个方法是为了显示字符的颜色的，如果这个cellState是选中的状态，就变成selectedMonthColor = 黄色。否则默认是白色，如果出了当月就是黑色。
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        }else{
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            }else{
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
    }
    
    // 本方法显示这个selectview是否是隐藏的，如果隐藏，就表示这一天是未选中的，如果被点击过了，那么isHidden就是false，这个view就会显示出来，默认在main.storyboard里是隐藏的。
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
        }
        
    }


}

extension ViewController: JTAppleCalendarViewDataSource{
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        // 把上面的日期范围的参数通过ConfigurationParameters方法丢进去
        let parameters = ConfigurationParameters (startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
}

extension ViewController:JTAppleCalendarViewDelegate{
    
    // 这个是JTAppleCalendar必须继承的，否则报错，可以为空。
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    // 显示cell的值
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
         handleCellTextColor(view: cell, cellState: cellState)
        return cell
        
    }
    
    // 选择的时候改变属性
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    
    // 不选中的时候改变属性
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
}

extension UIColor {
    convenience init(colorWithHexValue value:Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 16) / 255.0,
            blue: CGFloat((value & 0x000FF) >> 16) / 255.0,
            alpha: alpha
        )
    }
}
