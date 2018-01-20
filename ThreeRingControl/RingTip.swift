//
//  RingTip.swift
//  Phonercise
//
//  Created by Peter Salz on 20.01.18.
//
//  Copyright © 2016 Razeware LLC
//

import UIKit

class RingTip: CALayer
{
    // MARK: - Constituent Layers
    
    fileprivate lazy var tipLayer: CAShapeLayer =
    {
        let layer = CAShapeLayer()
        layer.lineCap = kCALineCapRound
        layer.lineWidth = self.ringWidth
        return layer
    }()
    
    fileprivate lazy var shadowLayer: CAShapeLayer =
    {
        let layer = CAShapeLayer()
        layer.lineCap = kCALineCapRound
        layer.strokeColor = UIColor.black.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 1.0
        layer.mask = self.shadowMaskLayer
        return layer
    }()
    
    fileprivate lazy var shadowMaskLayer: CAShapeLayer =
    {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.lineCap = kCALineCapButt
        return layer
    }()
    
    // MARK: - Utility properties
    
    fileprivate var radius: CGFloat
    {
        return (min(bounds.width, bounds.height) - ringWidth) / 2.0
    }
    
    fileprivate var tipPath: CGPath
    {
        return UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: -0.01,
                            endAngle: 0,
                            clockwise: true).cgPath
    }
    
    fileprivate var shadowMaskPath: CGPath
    {
        return UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: 0,
                            endAngle: CGFloat.pi/2,
                            clockwise: true).cgPath
    }
    
    // MARK: - API properties
    
    var color: CGColor = UIColor.red.cgColor
    {
        didSet
        {
            tipLayer.strokeColor = color
        }
    }
    
    var ringWidth: CGFloat = 40.0
    {
        didSet
        {
            tipLayer.lineWidth = ringWidth
            shadowLayer.lineWidth = ringWidth
            shadowMaskLayer.lineWidth = ringWidth
            preparePaths()
        }
    }
    
    // MARK: - Initialization
    
    override init()
    {
        super.init()
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
    override init(layer: Any)
    {
        super.init(layer: layer)
        if let layer = layer as? RingTip
        {
            color = layer.color
            ringWidth = layer.ringWidth
        }
    }
    
    fileprivate func sharedInitialization()
    {
        addSublayer(shadowLayer)
        addSublayer(tipLayer)
        color = UIColor.red.cgColor
        preparePaths()
    }
    
    // MARK: - Lifecycle overrides
    
    override func layoutSublayers()
    {
        for layer in [tipLayer, shadowLayer, shadowMaskLayer]
        {
            layer.bounds = bounds
            layer.position = center
        }
        
        preparePaths()
    }
    
    // MARK: - Utility methods
    
    fileprivate func preparePaths()
    {
        tipLayer.path = tipPath
        shadowLayer.path = tipPath
        shadowMaskLayer.path = shadowMaskPath
    }
}
