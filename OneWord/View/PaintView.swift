//
//  Board.swift
//  OneWord
//
//  Created by Songbai Yan on 10/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class PaintView: UIView {
    public var lineWidth:CGFloat = 1
    fileprivate var allLineArray = [[CGPoint]]()   //所有的线    记录每一条线
    fileprivate var currentPointArray = [CGPoint]() //当前画线的点  画完置空 增加到 线数组中
    fileprivate var allPointWidth = [CGFloat]()    //所有的线宽
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        //绘制之前的线
        if allLineArray.count > 0 {
            //遍历之前的线
            for i in 0..<allLineArray.count {
                let tmpArr = allLineArray[i]
                if tmpArr.count > 0 {
                    //画线
                    context?.beginPath()
                    //取出起始点
                    let sPoint:CGPoint = tmpArr[0]
                    context?.move(to: sPoint)
                    //取出所有当前线的点
                    for j in 0..<tmpArr.count {
                        let endPoint:CGPoint = tmpArr[j]
                        context?.addLine(to: endPoint)
                    }
                    context?.setLineWidth(allPointWidth[i])
                    context?.strokePath()
                }
            }
        }
        
        if currentPointArray.count > 0 {
            //绘制当前线
            context?.beginPath()
            context?.setLineWidth(self.lineWidth)
            context?.move(to: currentPointArray[0])
            print(currentPointArray[0])
            
            for i in 0..<currentPointArray.count {
                context?.addLine(to: currentPointArray[i])
                print(currentPointArray[i])
            }
            context?.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point:CGPoint = (event?.allTouches?.first?.location(in: self))!
        //路径起点
        currentPointArray.append(point)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point:CGPoint = (event?.allTouches?.first?.location(in: self))!
        //路径
        currentPointArray.append(point)
        
        //刷新视图
        self.setNeedsDisplay()
    }
    
    //触摸结束 存线 存线宽 清空当前线
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        allPointWidth.append(self.lineWidth)
        allLineArray.append(currentPointArray)
        currentPointArray.removeAll()
        self.setNeedsDisplay()
    }
    
    func cleanAll(){
        allLineArray.removeAll()
        currentPointArray.removeAll()
        allPointWidth.removeAll()
        self.setNeedsDisplay()
    }
}
