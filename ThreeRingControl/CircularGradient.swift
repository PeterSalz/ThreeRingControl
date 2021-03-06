//
//  CircularGradient.swift
//  Phonercise
//
//  Created by Peter Salz on 20.01.18.
//
//  Copyright © 2016 Razeware LLC
//

import CoreImage
import UIKit

private class CircularGradientFilter: CIFilter
{
    fileprivate lazy var kernel: CIColorKernel =
    {
        return self.createKernel()
    }()
    
    var outputSize: CGSize!
    var colors: (CIColor, CIColor)!
    
    override var outputImage: CIImage
    {
        let dod = CGRect(origin: .zero, size: outputSize)
        let args = [colors.0 as AnyObject,
                    colors.1 as AnyObject,
                    outputSize.width,
                    outputSize.height] as [Any]
        
        return kernel.apply(extent: dod, arguments: args)!
    }
    
    fileprivate func createKernel() -> CIColorKernel
    {
        let kernelString =
        "kernel vec4 chromaKey( __color c1, __color c2, float width, float height)\n" +
        "{\n" +
        "   vec2 pos = destCoord();\n" +
        "   float x = 1.0 - 2.0 * pos.x / width;\n" +
        "   float y = 1.0 - 2.0 * pos.y / height;\n" +
        "   float prop = atan(y,x) / (3.1415926535897932 * 2.0) + 0.5;\n" +
        "   return c1 * prop + c2 * (1.0 - prop);\n" +
        "}\n"
        
        return CIColorKernel(source: kernelString)!
    }
}

class CircularGradientLayer: CALayer
{
    fileprivate let gradientFilter = CircularGradientFilter()
    fileprivate let ciContext = CIContext(options: [kCIContextUseSoftwareRenderer: false])
    
    override init()
    {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        needsDisplayOnBoundsChange = true
    }
    
    override init(layer: Any)
    {
        super.init(layer: layer)
        needsDisplayOnBoundsChange = true
        if let layer = layer as? CircularGradientLayer
        {
            colors = layer.colors
        }
    }
    
    var colors: (CGColor, CGColor) = (UIColor.white.cgColor, UIColor.black.cgColor)
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext)
    {
        super.draw(in: ctx)
        
        gradientFilter.outputSize = bounds.size
        gradientFilter.colors = (CIColor(cgColor: colors.0), CIColor(cgColor: colors.1))
        let image = ciContext.createCGImage(gradientFilter.outputImage, from: bounds)
        ctx.draw(image!, in: bounds)
    }
}
