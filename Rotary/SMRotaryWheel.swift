//
//  SMRotaryWheel.swift
//  Rotary
//
//  Created by Phineas on 2018/11/25.
//  Copyright © 2018 Phineas. All rights reserved.
//

import UIKit
import QuartzCore

protocol SMRotaryProtocol: NSObjectProtocol {
    func wheelDidChangeValue(_ newValue: String)
}

class SMRotaryWheel: UIControl {
    
    weak var delegate: SMRotaryProtocol?
    var container: UIView!
    var numberOfSections: Int = 0
    
    var deltaAngle:CGFloat = 0.0
    
    var timer: Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, sectionsCount: Int) {

        self.init(frame: frame)
        self.numberOfSections = sectionsCount
        drawWheel()
        
//        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] (_) in
//            self?.rotate()
//        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawWheel() {
        container = UIView.init(frame: frame)
        
        container.backgroundColor = UIColor.gray
        let startPoint = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        startPoint.backgroundColor = UIColor.green
        container.addSubview(startPoint)
        
        let angleSize:Float = 2 * .pi / Float(numberOfSections)
        
        for i in 0 ..< numberOfSections {
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            label.backgroundColor = UIColor.red
            label.text = "index: \(i)"
            label.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            
            label.layer.position = CGPoint(x: container.bounds.size.width / 2.0 - container.frame.origin.x,
                                           y: container.bounds.size.height / 2.0 - container.frame.origin.y)
            
            label.transform = CGAffineTransform(rotationAngle: CGFloat(angleSize * Float(i)))
            label.tag = i
            
            container.addSubview(label)
        }
        
        container.isUserInteractionEnabled = false
        self.addSubview(container)
    }
    
    func rotate() {
        let radians:Float = -0.1
        let transform: CGAffineTransform = container.transform.rotated(by: CGFloat(radians))
        
        container.transform = transform
    }
    
}

extension SMRotaryWheel {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        let dist = calculateDistanceFromCenter(point)
        if (dist < 40 || dist > 100) {
            return false
        }
        
        let dx = point.x - container.center.x
        let dy = point.y - container.center.y
    
        deltaAngle = atan2(dy, dx)
        
        print("begin x:\(dx) y:\(dy) ang:\(deltaAngle)")
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let dx = point.x - container.center.x
        let dy = point.y - container.center.y
        
        let angle = atan2(dy, dx)
        
        print("continue x:\(dx) y:\(dy) ang:\(angle)")
        let angleDifference = deltaAngle - angle
        let transform: CGAffineTransform = container.transform.rotated(by: -angleDifference )
        container.transform = transform
        
        deltaAngle = angle
        
        return true
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let _ = touch?.location(in: self) else {
            return
        }
        
        let angleSize:CGFloat = 2 * .pi / CGFloat(numberOfSections)
        
        let tr: CGAffineTransform = container.transform
        let angle = atan2(tr.b, tr.a)
        let isPositive:CGFloat = angle > 0 ? 1.0 : -1.0

        let angleSizeDegree = angleSize * 180.0 / .pi
        let degree = angle * 180.0 / .pi
        print("endTracking - angleSizeDegree:\(angleSizeDegree) current degree:\(degree)")
        
        let segmentCount = abs(angle) / angleSize
        let segmentCountFullNumber = segmentCount - CGFloat(Int(segmentCount))
        let roundSegment = segmentCountFullNumber > 0.5 ? CGFloat(Int(segmentCount) + 1)*angleSize : CGFloat(Int(segmentCount))*angleSize
        let shift = isPositive * roundSegment - angle
    
        let transform: CGAffineTransform = container.transform.rotated(by: shift )
        container.transform = transform
        
    }
    
    func isNearRightSide(_ angle:CGFloat) -> Bool {
        return true
    }
    
    func calculateDistanceFromCenter(_ point: CGPoint) -> CGFloat {
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt(dx*dx + dy*dy)
    }
}
