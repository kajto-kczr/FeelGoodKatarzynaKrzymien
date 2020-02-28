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
    
    
    let uiColors: [UIColor] = [UIColor(red: 83/255, green: 119/255, blue: 166/255, alpha: 0.65),
                               UIColor(red: 2/255, green: 72/255, blue: 115/255, alpha: 0.45),
                               UIColor(red: 2/255, green: 89/255, blue: 89/255, alpha: 0.35),
                               UIColor(red: 2/255, green: 115/255, blue: 104/255, alpha: 0.45),
                               UIColor(red: 13/255, green: 13/255, blue: 13/255, alpha: 0.05)]
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
    
    override func viewWillAppear(_ animated: Bool) {
        let arr = UserDefaults.standard.array(forKey: "progressArray")
        guard arr != nil else { return }
        print(arr as! [String])
        for element in arr! {
            let line = element as! String
            let parts = line.components(separatedBy: ";")
            datesArray.append(parts[0])
            exercisesArray.append(parts[1])
        }

        var countArr: [Double] = []
        var count = 1.0
        for i in 0..<datesArray.count {
            if i == datesArray.count-1 {
                blueLinePlotData = countArr
                print(countArr)
                orangeLinePlotData = countArr
                let datesArrWithoutduplicates = datesArray.removeDuplicates()
                print("Dates: \(datesArrWithoutduplicates)")
                return
            }
            if datesArray[i] == datesArray[i+1] {
                count += 1
            } else {
                countArr.append(count)
                count = 1.0
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
        monthHeaderView.backgroundColor = uiColors[0] //3
        monthHeaderView.layer.cornerRadius = 10
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        weekDaysView.backgroundColor = uiColors[0] //3
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
        monthHeaderView.frame = CGRect(x: 0, y: view.frame.minY + 8, width: backgroundView.frame.width, height: backgroundView.frame.height * 0.08)
        //        monthHeaderView.center.x = view.center.x
        
        weekDaysView.frame = CGRect(x: 0, y: monthHeaderView.frame.maxY + 8, width: backgroundView.frame.width * 0.95, height: monthHeaderView.frame.height * 0.75)
        weekDaysView.center.x = view.center.x
        
        
        
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(x: 0, y: weekDaysView.frame.maxY, width: backgroundView.frame.width * 0.95, height: view.frame.height * 0.25)
            calendarView.center.x = view.center.x
            calendarView.setup()
        }
    }
    
    
    
    func setupGraph() {
        let calendarHeight = backgroundView.frame.height - (monthHeaderView.frame.minY + calendarView.frame.maxY)
        let frame = CGRect(x: 0, y: calendarView.frame.maxY, width: view.frame.width * 0.95, height: calendarHeight)
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.center.x = view.center.x
        graphView.layer.cornerRadius = 10
        
        
        // MARK: - first Line -
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        blueLinePlot.lineWidth = 1
        blueLinePlot.lineColor = uiColors[0]
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        blueLinePlot.shouldFill = true
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = uiColors[2].withAlphaComponent(0.5)
        blueLinePlot.adaptAnimationType = .elastic
        
        // MARK: - second Line -
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        orangeLinePlot.lineWidth = 1
        orangeLinePlot.lineColor = uiColors[1]
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        orangeLinePlot.shouldFill = true
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = uiColors[3].withAlphaComponent(0.5)
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
        //        self.view.addSubview(graphView)
        backgroundView.addSubview(graphView)
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch (plot.identifier) {
        case "multiBlue":
            return blueLinePlotData[pointIndex]
        case "multiOrange":
            return blueLinePlotData[pointIndex] + 2
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        let datesArrWithoutDuplicates = datesArray.removeDuplicates()
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

