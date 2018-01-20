//
//  Fanfare.swift
//  Phonercise
//
//  Created by Peter Salz on 20.01.18.
//
//  Copyright © 2016 Razeware LLC
//

import Foundation
import AVFoundation

public class Fanfare
{
    public var ringSound = "coin07"
    public var allRingSound = "winning"
    
    public static let sharedInstance = Fanfare()
    
    fileprivate var player: AVAudioPlayer?
    
    public func playSoundsWhenReady()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: RingCompletedNotification),
                                               object: nil,
                                               queue: OperationQueue.main)
        {   _ in
            self.playSound(self.ringSound)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AllRingsCompletedNotification),
                                               object: nil,
                                               queue: OperationQueue.main)
        {   _ in
            self.playSound(self.allRingSound)
        }
    }
    
    fileprivate func playSound(_ sound: String)
    {
        if let url = Bundle(for: type(of: self)).url(forResource: sound, withExtension: "mp3")
        {
            player = try? AVAudioPlayer(contentsOf: url)
            if player != nil
            {
                player!.numberOfLoops = 0
                player!.prepareToPlay()
                player!.play()
            }
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}
