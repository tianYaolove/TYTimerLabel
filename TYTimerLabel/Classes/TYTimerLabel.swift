//
//  TYCountDownLabel.swift
//  countDown
//
//  Created by 李田 on 2018/11/22.
//  Copyright © 2018年 tianyao. All rights reserved.
//

import UIKit

@objc enum TYCountDownLabelType: Int {
    case defaultType // 倒计时
    case incrementTimeType // 递增时间
}

/// 自定义代理
@objc protocol TYTimerLabelTypeDelegate: NSObjectProtocol {
    /**
     ** 方法: 根据参数的判断, 更改label的样式等(根据自己的需求)
     ** 参数label: 用来展示定时器输出文字的label
     ** 参数time: 对于倒计时来说就是当前剩余的时间间隔, 对于递增时间来说就是当前增加到的时间间隔
     **/
    @objc optional func changeTimerLabelAttrAtTime(label: UILabel, time: TimeInterval, type: TYCountDownLabelType)
    
    /**
     ** 方法: 自定义label文字的输出格式
     ** 参数label: 用来展示定时器输出文字的label
     ** 参数time: 对于倒计时来说就是当前剩余的时间间隔, 对于递增时间来说就是当前增加到的时间间隔
     ** 返回值: 自定义的字符串
    **/
    @objc optional func customTextToDisplayAtTime(label: UILabel, time: TimeInterval) -> String?
    /**
     ** 方法: 自定义label文字的输出格式
     ** 参数label: 用来展示定时器输出文字的label
     ** 参数time: 倒计时的总时间间隔
     **/
    @objc optional func countDownTimeOver(label: UILabel, time: TimeInterval)
}

// 默认时间间隔
let defaultTimeInterval = 0.1
let msTimeInterval = 0.01
// 时间格式
let defaultTimeFormatter = "HH:mm:ss"
class TYTimerLabel: UILabel {
    
    /// 设置代理
    weak var delegate: TYTimerLabelTypeDelegate?
    // 选择使用倒计时的类型
    fileprivate var type: TYCountDownLabelType?
    // 定时器
    fileprivate var timer: Timer?
    /// 时间间隔
    fileprivate var timeUserInterval: TimeInterval?
    // 初始时间
    fileprivate var startCountDate: Date?
    // label展示的时间
    fileprivate var timeToShow: Date?
    // 自1970年加上时间间隔后的时间
    fileprivate var timeToCountOff: Date?
    // 是否开始倒计时
    var counting: Bool = false
    /// 暂停时的时间
    fileprivate var pausedTime: Date?
    // dateIn1970时间
    fileprivate var dateIn1970: Date?
    // 倒计时是否结束
    fileprivate var isCountDownTimerEnded: Bool = false
    // 倒计时结束是否重置时间
    var isResetTime: Bool = false
    // 外部提供的label(承载倒计时)
    fileprivate var _label: UILabel?
    var label: UILabel? {
        get {
            if _label == nil {
                _label = self
            }
            return _label
        } set {
            _label = newValue
        }
    }
    // 时间格式类型
    fileprivate var _timeFormat: String?
    var timeFormat: String? {
        get {
            if _timeFormat == nil || (_timeFormat?.count ?? 0) == 0 {
                _timeFormat = defaultTimeFormatter
            }
            return _timeFormat
        } set {
            _timeFormat = newValue
            self.dateFormatter?.dateFormat = _timeFormat
            self.renewalLabel()
        }
    }
    
    // dateFormatter
    fileprivate var _dateFormatter: DateFormatter?
    fileprivate var dateFormatter: DateFormatter? {
        get {
            if _dateFormatter == nil {
                
                _dateFormatter = DateFormatter.init()
                /**
                 **不同地区有不同的日期格式。使用这个方法的目的：得到指定地区指定日期字段的一个合适的格式
                 **en_US(United States) : MM/dd/YYYY, HH:mm:ss;  en_GB(United Kingdom): dd/MM/YYYY, HH:mm:ss;  zh_CN(中国): YYYY/MM/dd HH:mm:ss
                 **/
                _dateFormatter?.locale = Locale(identifier: "en_GB")
                /**
                 **时区:  任何时区都以GMT为准
                 ** iOS中的时间类NSDate所获取到的时间, 都是相对于GMT的
                 **/
                _dateFormatter?.timeZone = TimeZone(identifier: "GMT")
                _dateFormatter?.dateFormat = self.timeFormat
            }
            return _dateFormatter
        } set {
            _dateFormatter = newValue
        }
    }
    
    //    MARK: 便利构造函数
     convenience init(label: UILabel) {
        self.init(frame: .zero, label: label, type: .defaultType)
    }
    convenience init(label: UILabel, type: TYCountDownLabelType) {
        self.init(frame: .zero, label: label, type: type)
    }
    init(frame: CGRect, label: UILabel?, type: TYCountDownLabelType) {
        super.init(frame: frame)
        self.type = type
        self.label = label
        setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //    MARK: 传入时间间隔
    func countDownTimeWithTimeInterval(timeInterval: TimeInterval) {
        timeUserInterval = timeInterval
        timeToCountOff = dateIn1970?.addingTimeInterval(timeUserInterval ?? TimeInterval())
        renewalLabel()
    }
    //    MARK: 传入日期
    func countDownTimeWithDate(date: Date) {
        // 传入是时间距当前时间的时间间隔
        let timeInterval = date.timeIntervalSince(Date())
        if timeInterval > 0 {
            timeUserInterval = timeInterval
            timeToCountOff = dateIn1970?.addingTimeInterval(timeUserInterval ?? TimeInterval())
        } else {
            timeUserInterval = 0
            timeToCountOff = dateIn1970?.addingTimeInterval(0)
        }
        renewalLabel()
    }
    //    MARK: 递增时间传入初始的时间戳
    func incrementTimeWithTimeInterval(interval: TimeInterval) {
        timeUserInterval = (interval < 0) ? 0 : interval
        if (timeUserInterval ?? 0) > 0 {
            startCountDate = Date().addingTimeInterval(-(timeUserInterval ?? 0))
            pausedTime = Date()
            renewalLabel()
        }
    }
    
    //    MARK: 创建启动定时器
    func start() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        if (timeFormat?.contains("SS"))! {
            // 创建定时器
            timer = Timer.scheduledTimer(timeInterval: msTimeInterval, target: self, selector: #selector(renewalLabel), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: defaultTimeInterval, target: self, selector: #selector(renewalLabel), userInfo: nil, repeats: true)
        }

        // 把定时器添加到当前线程, 并更改其模式为commonModes(不受其他控件的影响)
        RunLoop.current.add(timer ?? Timer(), forMode: .commonModes)
        
        if startCountDate == nil {
            startCountDate = Date()
        }
        if pausedTime != nil {
            // 暂停时间与开始时间的时间间隔
            let timeInterval = pausedTime?.timeIntervalSince(startCountDate ?? Date())
            // 重新给startCountDate赋值---startCountDate等于当前的时间减去暂停时间已开始时间的时间间隔, 因为在renewalLabel中, timeDiff是当前时间与startCountDate的时间间隔, 如果是倒计时, timeDiff是已经完成倒计时的时间, 所以这里startCountDate要减去暂停时间与开始时间的时间间隔
            startCountDate = Date().addingTimeInterval(-(timeInterval ?? 0))
            pausedTime = nil
        }
        counting = true
        timer?.fire()
    }
    
    //    MARK: 暂停
    func pause() {
        if counting {
            timer?.invalidate()
            timer = nil
            counting = false
            pausedTime = Date()
        }
    }
    
    //    MARK: 重置
    func reset() {
        pausedTime = nil
        timeUserInterval = (type == TYCountDownLabelType.defaultType) ? timeUserInterval : 0
        startCountDate = counting ? Date() : nil
    }
    
    //    MARK: 搭建界面
    private func setupUI() {
        // 获取1970-01-01 00:00:00时间
        dateIn1970 = Date(timeIntervalSince1970: 0)
    }
    
    //    MARK: 更新label数据
    @objc private func renewalLabel() {
        
        // 获取当前时间与startCountDate的时间间隔
        let timeDiff = Date().timeIntervalSince(startCountDate ?? Date())
        
        if type == TYCountDownLabelType.defaultType {
            // 倒计时
            delegate?.changeTimerLabelAttrAtTime?(label: label ?? self, time: ((timeUserInterval ?? 0) - timeDiff), type: type ?? TYCountDownLabelType.defaultType)
            if counting {
                if timeDiff >= (timeUserInterval ?? 0) {
                    pause()
                    timeToShow = dateIn1970?.addingTimeInterval(0)
                    startCountDate = nil
                    isCountDownTimerEnded = true
                } else {
                    timeToShow = timeToCountOff?.addingTimeInterval(-timeDiff)
                }
            } else {
                timeToShow = timeToCountOff
            }
        }  else {
            // 递增时间
            if counting {
                delegate?.changeTimerLabelAttrAtTime?(label: label ?? self, time: timeDiff, type: type ?? TYCountDownLabelType.defaultType)
                timeToShow = dateIn1970?.addingTimeInterval(timeDiff)
            } else {
                timeToShow = dateIn1970?.addingTimeInterval((startCountDate == nil) ? 0 : timeDiff)
            }
        }
        
        
        let timeLeft = (type == TYCountDownLabelType.incrementTimeType) ? timeDiff : ((timeUserInterval ?? 0) - timeDiff) > 0 ? ((timeUserInterval ?? 0) - timeDiff) : 0
        let labelText = delegate?.customTextToDisplayAtTime?(label: label ?? self, time: timeLeft)
        if let text = labelText {
            label?.text = text
            return
        }
        label?.text = dateFormatter?.string(from: timeToShow ?? Date())
        
        // 倒计时是否结束
        if isCountDownTimerEnded {
            delegate?.countDownTimeOver?(label: label ?? self, time: timeUserInterval ?? 0)
            // 是否自动重置倒计时时间
            if isResetTime {
                reset()
            }
        }
    }
    
    //    MARK: 获取已经消耗的时间
    func getConsumeTime() -> TimeInterval {
        if startCountDate != nil {
            var consumeTime = Date().timeIntervalSince(startCountDate ?? Date())
            if pausedTime != nil {
                let pausedTime = Date().timeIntervalSince(self.pausedTime ?? Date())
                consumeTime -= pausedTime
            }
            return consumeTime
        } else {
            return 0
        }
    }
    
    //    MARK: 获取剩余的倒计时时间
    func residueTime() -> TimeInterval {
        if type == TYCountDownLabelType.defaultType {
            return (timeUserInterval ?? 0) - getConsumeTime()
        } else {
            return 0
        }
    }
    
    //    MARK: 获取倒计时总时间
    func getCountDownTime() -> TimeInterval {
        if type == TYCountDownLabelType.defaultType {
            return timeUserInterval ?? 0
        } else {
            return 0
        }
    }
    
    //    MARK: 销毁定时器
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
