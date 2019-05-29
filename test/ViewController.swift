import UIKit
import JTAppleCalendar

class ViewController: UIViewController, SBCardPopupContent {
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    let testCalendar = Calendar(identifier: .gregorian)
    @IBOutlet weak var monthTitlee: UILabel!
    
    weak var popupViewController: SBCardPopupViewController?
    let allowsTapToDismissPopupCard = true
    let allowsSwipeToDismissPopupCard = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
//        calendarView.scrollToDate(Date())
        
        self.calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0)
        
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true


        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.0
        calendarView.addGestureRecognizer(panGensture)
    }
    
    @objc func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let rangeSelectedDates = calendarView.selectedDates // fechas seleccionadas

        guard let cellState = calendarView.cellStatus(at: point) else { return } // fecha actual seleccionada

        if !rangeSelectedDates.contains(cellState.date) {

            let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? cellState.date, to: cellState.date)

            guard !dateRange.isEmpty else {
                calendarView.deselectAllDates()
                return
            }

            calendarView.selectDates(dateRange, keepSelectionIfMultiSelectionAllowed: true)

        } else {
            let followingDay = testCalendar.date(byAdding: .day, value: 1, to: cellState.date)!
            calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
        }
    }
    
    // funciones para ver en UI los datos de entradas, los de salidas y mes
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            // colores de texto de este mes
            cell.dateLabel.textColor = UIColor.black
            // mostrar las fechas que son del mes
            // cell.isHidden = false
        } else {
            // colores de texto que no son del mes
            cell.dateLabel.textColor = UIColor.gray
            // ocultar las fechas que no son del mes
            // cell.isHidden = true
        }
    }
    
    // FIN funciones para ver en UI los datos de entradas, los de salidas y mes
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {

        let today = Date()
        
        if (today < cellState.date) {
            cell.contentView.alpha = 0.1
        } else {
            cell.selectedView.isHidden = !cellState.isSelected
        }

        switch cellState.selectedPosition() {
        case .left:
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.layer.cornerRadius = 18
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.layer.cornerRadius = 18
            cell.selectedView.layer.maskedCorners = []
        case .right:
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.layer.cornerRadius = 18
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.layer.cornerRadius = 18
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        default: break
        }

    }
    
    static func create() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        return viewController
    }

    @IBAction func goBack(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func goNext(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
}

extension ViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"

        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .off, generateOutDates: .off)
    }
}

extension ViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.contentView.alpha = 1
        cell.selectedView.isHidden = true
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // header
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM"
        print("month: ", formatter.string(from: range.start))
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
//        header.monthTitle.text = formatter.string(from: range.start)
        monthTitlee.text = formatter.string(from: range.start)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
}
