//
//  PieChart.swift
//  Schrodinger
//
//  Created by ido on 2021/08/02.
//

import UIKit

class PieChart: UIView {
    
    var start: CGFloat = (-(.pi) / 2)
    var end: CGFloat = 0.0
    var values = [85, 30]
    let pieLabel = ["Use All", "Throw away"]
    var currentIndex = 0
    var pieCenter = CGPoint.zero
    
    let pieColors = [UIColor.systemGreen, UIColor.systemPink]
    
    override func draw(_ rect: CGRect) {
        self.pieCenter = CGPoint(x: rect.midX, y: rect.midY)
        let total = self.values.reduce(0, +)
        let radius = min(rect.width, rect.width) / 2
        var status = 0
        
        values.forEach { value in
            end = (CGFloat(value) / CGFloat(total)) * (.pi * 2)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(
                withCenter: center,
                radius: radius,
                startAngle: start,
                endAngle: start + end,
                clockwise: true)
            
            pieColors[status].set()
            path.fill()
            start += end
            path.close()
            
            UIColor.systemBackground.set()
            path.lineWidth = 5
            path.stroke()
            
            //MARK: Check why print 0.0
            print(value)
            let duringAngle: CGFloat = CGFloat((value / 100) * 360)
            print(duringAngle)
            let halfDegree = (duringAngle * .pi) / 180
            
            let pieX = rect.midX + ((radius/2) * sin((halfDegree/2) + start))
            let pieY = rect.midY - ((radius/2) * cos((halfDegree/2) + start))
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 20))
            label.center = CGPoint(x: pieX, y: pieY)
            label.textAlignment = .center
            label.text = pieLabel[status]
            label.font = UIFont.boldSystemFont(ofSize: 12)
            
            switch duringAngle {
            case 0..<15 :
                label.font = label.font.withSize(10)
            case 30..<45 :
                label.font = label.font.withSize(16)
            case 45..<360 :
                label.font = label.font.withSize(20)
            
            default:
                label.font = label.font.withSize(12)
            }
            
            label.textColor = .systemBackground
            self.addSubview(label)
            status += 1
        }
    }
    
}
