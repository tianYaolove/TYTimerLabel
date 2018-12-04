//
//  ViewController.swift
//  countDown
//
//  Created by 李田 on 2018/11/22.
//  Copyright © 2018年 tianyao. All rights reserved.
//

import UIKit

class TYTimerViewController: UIViewController {
    
    var timer: TYTimerLabel?
    var incrementTimer: TYTimerLabel?
    var count: Int = 0
    var type: String = "default"
    
    //    MARK: 懒加载
    private lazy var modeConversionBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .cyan
        btn.setTitle("modo Conversion", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 36)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(modeConversionBtnAction), for: .touchUpInside)
        return btn
    }()
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = boldFontSizeXP(fontS: 60)
        return label
    }()
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brown
        btn.setTitle("start", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 28)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.tag = 1
        btn.addTarget(self, action: #selector(startBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    private lazy var stopBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brown
        btn.setTitle("stop", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 28)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.tag = 2
        btn.addTarget(self, action: #selector(stopBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    private lazy var resetBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brown
        btn.setTitle("reset", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 28)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.tag = 3
        btn.addTarget(self, action: #selector(resetBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    private lazy var incrementTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "nisioj"
        label.textColor = .white
        label.font = boldFontSizeXP(fontS: 60)
        return label
    }()
    private lazy var incrementStartBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brown
        btn.setTitle("start", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 28)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.tag = 4
        btn.addTarget(self, action: #selector(startBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    private lazy var incrementStopBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brown
        btn.setTitle("stop", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 28)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.tag = 5
        btn.addTarget(self, action: #selector(stopBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    private lazy var incrementResetBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brown
        btn.setTitle("reset", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = boldFontSizeXP(fontS: 28)
        btn.layer.cornerRadius = kScreenPortionH(h: 10)
        btn.layer.masksToBounds = true
        btn.tag = 6
        btn.addTarget(self, action: #selector(resetBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createTimerLabel()
    }
    //    MARK: 切换模式
    @objc private func modeConversionBtnAction() {
        switch count % 5 {
        case 0:
            timer?.timeFormat = "HH:mm:ss"
            incrementTimer?.timeFormat = "HH:mm:ss"
            timer?.start()
            incrementTimer?.start()
            type = "default"
            break
        case 1:
            timer?.timeFormat = "mm:ss"
            incrementTimer?.timeFormat = "mm:ss"
            timer?.start()
            incrementTimer?.start()
            type = "default"
            break
        case 2:
            timer?.timeFormat = "ss"
            incrementTimer?.timeFormat = "ss"
            timer?.start()
            incrementTimer?.start()
            type = "default"
            break
        case 3:
            timer?.start()
            incrementTimer?.start()
            type = "custom"
            break
        case 4:
            timer?.timeFormat = "HH:mm:ss SS"
            incrementTimer?.timeFormat = "HH:mm:ss SS"
            timer?.start()
            incrementTimer?.start()
            type = "default"
            break
        default:
            break
        }
        count += 1
    }
    //    MARK: 开启定时器
    @objc private func startBtnAction(btn: UIButton) {
        if btn.tag == 1 {
            timer?.start()
        } else {
            incrementTimer?.start()
        }
    }
    //    MARK: 暂停定时器
    @objc private func stopBtnAction(btn: UIButton) {
        if btn.tag == 2 {
            timer?.pause()
        } else {
            incrementTimer?.pause()
        }
    }
    //    MARK: 重置定时器
    @objc private func resetBtnAction(btn: UIButton) {
        if btn.tag == 3 {
            timer?.reset()
        } else {
            incrementTimer?.reset()
        }
    }
    
    //    MARK: 创建定时器Label
    func createTimerLabel() {
        let dateFormatter = DateFormatter()
        let time = "2018-11-29 12:32:25"
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let dateTime = dateFormatter.date(from: time)
        
        timer = TYTimerLabel.init(label: timerLabel, type: .defaultType)
//        timer?.countDownTimeWithDate(date: dateTime ?? Date())
        timer?.countDownTimeWithTimeInterval(timeInterval: 60)
        timer?.timeFormat = "HH:mm:ss"
        timer?.isResetTime = true
        timer?.delegate = self
        
        incrementTimer = TYTimerLabel.init(label: incrementTimerLabel, type: .incrementTimeType)
        incrementTimer?.incrementTimeWithTimeInterval(interval: 0)
        incrementTimer?.timeFormat = "HH:mm:ss SS"
        incrementTimer?.delegate = self
    }
    
    //    MARK: 搭建界面
    func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.6, alpha: 0.5)
        
        view.addSubview(modeConversionBtn)
        view.addSubview(timerLabel)
        view.addSubview(startBtn)
        view.addSubview(stopBtn)
        view.addSubview(resetBtn)
        view.addSubview(incrementTimerLabel)
        view.addSubview(incrementStartBtn)
        view.addSubview(incrementStopBtn)
        view.addSubview(incrementResetBtn)
        
        modeConversionBtn.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        startBtn.translatesAutoresizingMaskIntoConstraints = false
        stopBtn.translatesAutoresizingMaskIntoConstraints = false
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        incrementTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        incrementStartBtn.translatesAutoresizingMaskIntoConstraints = false
        incrementStopBtn.translatesAutoresizingMaskIntoConstraints = false
        incrementResetBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 布局
        // modeConversionBtn
        view.addConstraint(NSLayoutConstraint(item: modeConversionBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: modeConversionBtn, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: kScreenPortionH(h: 150)))
        view.addConstraint(NSLayoutConstraint(item: modeConversionBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 340)))
        view.addConstraint(NSLayoutConstraint(item: modeConversionBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 90)))
        // timerLabel
        view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: kScreenPortionH(h: 400)))
        // startBtn
        view.addConstraint(NSLayoutConstraint(item: startBtn, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: kScreenPortionW(w: 80)))
        view.addConstraint(NSLayoutConstraint(item: startBtn, attribute: .top, relatedBy: .equal, toItem: timerLabel, attribute: .bottom, multiplier: 1, constant: kScreenPortionH(h: 60)))
        view.addConstraint(NSLayoutConstraint(item: startBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 120)))
        view.addConstraint(NSLayoutConstraint(item: startBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 60)))
        // stop
        view.addConstraint(NSLayoutConstraint(item: stopBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: stopBtn, attribute: .top, relatedBy: .equal, toItem: startBtn, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: stopBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 120)))
        view.addConstraint(NSLayoutConstraint(item: stopBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 60)))
        // reset
        view.addConstraint(NSLayoutConstraint(item: resetBtn, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: kScreenPortionW(w: -80)))
        view.addConstraint(NSLayoutConstraint(item: resetBtn, attribute: .top, relatedBy: .equal, toItem: startBtn, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: resetBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 120)))
        view.addConstraint(NSLayoutConstraint(item: resetBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 60)))
        // incrementTimerLabel
        view.addConstraint(NSLayoutConstraint(item: incrementTimerLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: incrementTimerLabel, attribute: .top, relatedBy: .equal, toItem: startBtn, attribute: .bottom, multiplier: 1, constant: kScreenPortionH(h: 200)))
        // incrementStartBtn
        view.addConstraint(NSLayoutConstraint(item: incrementStartBtn, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: kScreenPortionW(w: 80)))
        view.addConstraint(NSLayoutConstraint(item: incrementStartBtn, attribute: .top, relatedBy: .equal, toItem: incrementTimerLabel, attribute: .bottom, multiplier: 1, constant: kScreenPortionH(h: 60)))
        view.addConstraint(NSLayoutConstraint(item: incrementStartBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 120)))
        view.addConstraint(NSLayoutConstraint(item: incrementStartBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 60)))
        // incrementStopBtn
        view.addConstraint(NSLayoutConstraint(item: incrementStopBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: incrementStopBtn, attribute: .top, relatedBy: .equal, toItem: incrementStartBtn, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: incrementStopBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 120)))
        view.addConstraint(NSLayoutConstraint(item: incrementStopBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 60)))
        // incrementResetBtn
        view.addConstraint(NSLayoutConstraint(item: incrementResetBtn, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: kScreenPortionW(w: -80)))
        view.addConstraint(NSLayoutConstraint(item: incrementResetBtn, attribute: .top, relatedBy: .equal, toItem: incrementStartBtn, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: incrementResetBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionW(w: 120)))
        view.addConstraint(NSLayoutConstraint(item: incrementResetBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kScreenPortionH(h: 60)))
    }
}

extension TYTimerViewController: TYTimerLabelTypeDelegate {
    //    MARK: 自定义label的样式
    func changeTimerLabelAttrAtTime(label: UILabel, time: TimeInterval, type: TYCountDownLabelType) {
        if label == timerLabel {
            if time < 55 {
                label.textColor = .red
            } else {
                label.textColor = .white
            }
        }
    }
    //    MARK: 自定义文字输出内容
    func customTextToDisplayAtTime(label: UILabel, time: TimeInterval) -> String? {
        if type == "custom" {
            let hours = Int(time / 3600)
            let minutes = Int((time - Double(hours * 3600)) / 60)
            let seconds = Int(time - Double(hours * 3600) - Double(minutes * 60))
            return "\(hours)" + "h" + "\(minutes)" + "min" + "\(  seconds)" + "s"
        } else {
            return nil
        }
    }
    //    MARK: 倒计时结束
    func countDownTimeOver(label: UILabel, time: TimeInterval) {
        label.text = "game over"
    }
}

