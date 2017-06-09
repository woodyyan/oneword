//
//  CircularlyPagedScrollView.swift
//  OneWord
//
//  Created by Songbai Yan on 06/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class CircularlyPagedScrollView: UIScrollView, UIScrollViewDelegate {
    /// All the views in the loop.
    var viewsToRotate: [UIView]!
    /// Scolls vertically if false.
    var scrollHorizontally: Bool = true
    
    /// Three views to be actually shown on the scollView.
    var viewsShown: [UIView]! {
        didSet {
            contentOffset = secondOrigin
            zip(viewsShown, origins).forEach {
                $0.0.frame = CGRect(origin: $0.1, size: $0.0.frame.size)
                addSubview($0.0)
            }
        }
    }
    
    var pageWidth: CGFloat {
        return viewsToRotate.first == nil ? CGFloat(0) : viewsToRotate.first!.frame.width
    }
    var pageHeight: CGFloat {
        return viewsToRotate.first == nil ? CGFloat(0) : viewsToRotate.first!.frame.height
    }
    var contentWidth: CGFloat {
        return pageWidth * CGFloat(scrollHorizontally ? viewsToRotate.count : 1)
    }
    var contentHeight: CGFloat {
        return pageHeight * CGFloat(scrollHorizontally ? 1 : viewsToRotate.count)
    }
    /// Origin of first shown view.
    var firstOrigin: CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    /// Origin of second shown view.
    var secondOrigin: CGPoint {
        return CGPoint(x: (scrollHorizontally ? firstOrigin.x + pageWidth : firstOrigin.x), y: (scrollHorizontally ? firstOrigin.y : firstOrigin.y + pageHeight))
    }
    /// Origin of third shown view.
    var thirdOrigin: CGPoint {
        return CGPoint(x: (scrollHorizontally ? secondOrigin.x + pageWidth : secondOrigin.x), y: (scrollHorizontally ? secondOrigin.y : secondOrigin.y + pageHeight))
    }
    /// Origins of the three shown view
    var origins: [CGPoint] {
        return [firstOrigin, secondOrigin, thirdOrigin]
    }
    
    convenience init(frame: CGRect, viewsToRotate: [UIView], scrollHorizontally: Bool = true) {
        self.init(frame: frame)
        self.scrollHorizontally = scrollHorizontally
        self.viewsToRotate = viewsToRotate
        self.contentSize = CGSize(width: self.contentWidth, height: self.contentHeight)
        self.contentOffset = self.secondOrigin
        self.isPagingEnabled = true
    }
    
    func resetMiddleViewShown(middle: UIView) {
        viewsToRotate.forEach { $0.removeFromSuperview() }
        guard let updatedViewsShown = viewsToRotate.formThreeCircularlyConsecutiveElements(middle: middle) else {
            fatalError("No view to show.")
        }
        viewsShown = updatedViewsShown
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var viewInMiddle: UIView? = nil
        if scrollHorizontally {
            if contentOffset.x == 0 || contentOffset.x == pageWidth * 2 {
                if contentOffset.x == 0 {
                    viewInMiddle = viewsShown[0]
                }
                if contentOffset.x == pageWidth * 2 {
                    viewInMiddle = viewsShown[2]
                }
            }
        } else {
            if contentOffset.y == 0 || contentOffset.y == pageHeight * 2 {
                if contentOffset.y == 0 {
                    viewInMiddle = viewsShown[0]
                }
                if contentOffset.y == pageHeight * 2 {
                    viewInMiddle = viewsShown[2]
                }
            }
        }
        if let view = viewInMiddle {
            resetMiddleViewShown(middle: view)
        }
    }
}

extension Array where Element: NSObject {
    /// Given elements of an array, the elements on both ends are connected with
    /// each other (circularl), pick any three consecutive elements with a given
    /// middle element.
    /// If there are less than three elements in the array, copy existing one(s)
    /// to generate what we want.
    /// If empty, return nil.
    func formThreeCircularlyConsecutiveElements(middle: Element) -> [Element]? {
        
        func consLastElement() -> Array? {
            return last == nil ? nil : [last!.isEqual(middle) ? middle.copy() as! Element : last!] + self
        }
        
        func appendFirstElement() -> Array? {
            return first == nil ? nil : self + [first!.isEqual(middle) ? middle.copy() as! Element : first!]
        }
        
        guard let i = index(where: { middle.isEqual($0) }) else {
            return nil
        }
        var arrayToOperate = self
        if i == startIndex {
            arrayToOperate = consLastElement()!
        }
        if i == endIndex - 1 {
            arrayToOperate = appendFirstElement()!
        }
        guard let j = arrayToOperate.index(where: { middle.isEqual($0) }) else {
            return nil
        }
        return [arrayToOperate[j.advanced(by: -1)], middle, arrayToOperate[j.advanced(by: 1)]]
    }
}
