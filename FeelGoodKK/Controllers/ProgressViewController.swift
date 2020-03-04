//
//  ProgressViewController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 24.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit
import VACalendar
import ScrollableGraphView


class ProgressViewController: UIViewController, ScrollableGraphViewDataSource {
    
    
    let uiColors: [UIColor] = [UIColor(red: 8/255, green: 74/255, blue: 89/255, alpha: 1),
                               UIColor(red: 25/255, green: 98/255, blue: 115/255, alpha: 0.45),
                               UIColor(red: 109/255, green: 155/255, blue: 166/255, alpha: 0.65),
                               UIColor(red: 191/255, green: 214/255, blue: 217/255, alpha: 0.85),
                               UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.95)]
    static let identifier = String(describing: ProgressViewController.self)
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            
            let appereance = VAMonthHeaderViewAppearance(monthTextColor: .white, dateFormatter: dateFormatter)
            monthHeaderView.appearance = appereance
            
        }
    }
    
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance  = VAWeekDaysViewAppearance(symbolsType: .short, weekDayTextColor: .white, calendar: defaultCalender)
            weekDaysView.appearance = appereance
        }
    }
    
    let defaultCalender: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.timeZone = TimeZone(secondsFromGMT: 3600)!
        return calendar
    }()
    
    var calendarView: VACalendarView!
    var blueLinePlotData: [Double] = []
    var orangeLinePlotData: [Double] = []
    var datesArray: [String] = []
    var exercisesArray: [String] = []
    var completeDatesArray: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        let arr = UserDefaults.standard.array(forKey: "progressArray")
        guard arr != nil else {
            blueLinePlotData = [0, 0]
            orangeLinePlotData = [0, 0]
            let today = Date()
            let tommorow = Date(timeInterval: 86400, since: today)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            datesArray.append(formatter.string(from: today))
            datesArray.append(formatter.string(from: tommorow))
            getMissingDates(firstDate: datesArray[0], secondDate: datesArray[datesArray.count-1])
            return
        }
        
        for element in arr! {
            let line = element as! String
            let parts = line.components(separatedBy: ";")
            datesArray.append(parts[0])
            exercisesArray.append(parts[1])
        }
        
        if datesArray.removeDuplicates().count == 1 {
            let tommorow = Date(timeInterval: 86400, since: Date())
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            datesArray.append(formatter.string(from: tommorow))
        }
        getMissingDates(firstDate: datesArray[0], secondDate: datesArray[datesArray.count-1])
        
        var countArr: [Double] = []
        var count = 0.0
        for i in 0..<completeDatesArray.count {
            if i == completeDatesArray.count - 1 {
                blueLinePlotData = countArr
                orangeLinePlotData = countArr
                return
            }
            if datesArray.contains(completeDatesArray[i]) {
                for element in datesArray {
                    if element == completeDatesArray[i] {
                        count += 1
                    }
                }
                countArr.append(count)
                count = 0
            } else {
                countArr.append(count)
                count = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Calender -
        let calendar = VACalendar(calendar: defaultCalender)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        
        
        backgroundView.addSubview(calendarView)
        
        
        backgroundView.backgroundColor = uiColors[1]
        monthHeaderView.backgroundColor = uiColors[0].withAlphaComponent(0.5) //3
        monthHeaderView.layer.cornerRadius = 10
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        weekDaysView.backgroundColor = uiColors[0].withAlphaComponent(0.5)
        weekDaysView.layer.cornerRadius = 10
        
        // MARK: - Graph -
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.setupGraph()
            let dates = self.convertStringToDate(dates: self.datesArray)
            for date in dates {
                self.calendarView.setSupplementaries([(date, [VADaySupplementary.bottomDots([self.uiColors[1], self.uiColors[0]])])])
            }
        })
    }
    
    func convertStringToDate(dates: [String]) -> [Date] {
        var newDateArray: [Date] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -3600)
        for date in dates {
            let newDate = dateFormatter.date(from: date)
            newDateArray.append(newDate!)
        }
        return newDateArray
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        monthHeaderView.frame = CGRect(x: 0, y: view.frame.minY + 8, width: backgroundView.frame.width * 0.95, height: backgroundView.frame.height * 0.08)
        monthHeaderView.center.x = view.center.x
        
        weekDaysView.frame = CGRect(x: 0, y: monthHeaderView.frame.maxY + 8, width: backgroundView.frame.width * 0.95, height: monthHeaderView.frame.height * 0.75)
        weekDaysView.center.x = view.center.x
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(x: 0, y: weekDaysView.frame.maxY, width: backgroundView.frame.width * 0.95, height: view.frame.height * 0.25)
            calendarView.center.x = view.center.x
            calendarView.setup()
        }
    }
    
    func getMissingDates(firstDate: String, secondDate: String) {
        let dictMonthLastDay: [String:Int] = ["01":31, "02":28, "03":31, "04":30, "05":31, "06":30, "07":31, "08":31, "09":30, "10":31, "11":30, "12":31]
        var count = 0
        
        let start = firstDate.index(firstDate.startIndex, offsetBy: 5)
        let end = firstDate.index(firstDate.startIndex, offsetBy: 7)
        let range = start..<end
        
        let firstDay = Int(String(firstDate.suffix(2)))!
        let firstMonth = String(firstDate[range])
        let secondDay = Int(String(secondDate.suffix(2)))!
        let secondMonth = String(secondDate[range])
        
        let monthDifference = (Int(secondMonth)! - Int(firstMonth)!) - 1
        
        if monthDifference > 0 {
            for i in 0...monthDifference {
                if i == 0 {
                    continue
                }
                
                var monthAfter = String(Int(firstMonth)! + i)
                if monthAfter.count == 1 {
                    monthAfter.insert("0", at: monthAfter.startIndex)
                }
                let daysMonthsBetween = dictMonthLastDay[monthAfter]
                count += daysMonthsBetween!
            }
            count += secondDay
            let missingDaysFirstMonth = dictMonthLastDay[String(firstMonth)]! - firstDay
            count += (missingDaysFirstMonth + 1)
        } else if monthDifference == 0 {
            count = (dictMonthLastDay[firstMonth]! - (firstDay-1)) + secondDay
        } else {
            count = secondDay - firstDay
        }
        
        var currentDay = firstDay
        var currentMonth = firstMonth
        
        
        for i in 0..<count {
            if i == 0 {
                if String(currentDay).count == 2 {
                    completeDatesArray.append("2020-"+currentMonth+"-"+String(currentDay))
                    continue
                } else {
                    var newDayString = String(currentDay)
                    newDayString.insert("0", at: newDayString.startIndex)
                    completeDatesArray.append("2020-"+currentMonth+"-"+newDayString)
                }
            }
            
            currentDay += 1
            if currentDay > dictMonthLastDay[currentMonth]! {
                currentDay -= dictMonthLastDay[currentMonth]!
                let newMonth = Int(currentMonth)! + 1
                currentMonth = String(newMonth)
                if currentMonth.count == 1 {
                    currentMonth.insert("0", at: currentMonth.startIndex)
                }
            }
            var stringDay = String(currentDay)
            if stringDay.count == 1 {
                stringDay.insert("0", at: stringDay.startIndex)
            }
            completeDatesArray.append("2020-"+currentMonth+"-"+stringDay)
        }
    }
    
    func setupGraph() {
        let calendarHeight = backgroundView.frame.height - (monthHeaderView.frame.minY + calendarView.frame.maxY)
        let frame = CGRect(x: 0, y: calendarView.frame.maxY, width: view.frame.width * 0.95, height: calendarHeight)
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.center.x = view.center.x
        graphView.direction = .rightToLeft
        graphView.layer.cornerRadius = 10
        
        // MARK: - first Line -
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        blueLinePlot.lineWidth = 1
        blueLinePlot.lineColor = uiColors[0]
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        blueLinePlot.shouldFill = true
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = uiColors[0].withAlphaComponent(0.5)
        blueLinePlot.adaptAnimationType = .elastic
        
        // MARK: - second Line -
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        orangeLinePlot.lineWidth = 1
        orangeLinePlot.lineColor = uiColors[1]
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        orangeLinePlot.shouldFill = true
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = uiColors[1].withAlphaComponent(0.5)
        orangeLinePlot.adaptAnimationType = .elastic
        
        // MARK: - reference Lines -
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white
        
        graphView.backgroundFillColor = uiColors[1]
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: orangeLinePlot)
        backgroundView.addSubview(graphView)
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch (plot.identifier) {
        case "multiBlue":
            return blueLinePlotData[pointIndex]
        case "multiOrange":
            return blueLinePlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        //        let datesArrWithoutDuplicates = datesArray.removeDuplicates()
        let datesArrWithoutDuplicates = completeDatesArray.removeDuplicates()
        return "\(datesArrWithoutDuplicates[pointIndex])"
    }
    
    func numberOfPoints() -> Int {
        return blueLinePlotData.count
    }
}

extension ProgressViewController: VAMonthViewAppearanceDelegate {
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
}

extension ProgressViewController: VADayViewAppearanceDelegate {
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return uiColors[1]
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .white
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return uiColors[2]
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
}

extension ProgressViewController: VACalendarViewDelegate {
    func selectedDates(_ dates: [Date]) {
        print(dates)
    }
}

