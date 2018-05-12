//
//  ViewController.swift
//  HeadphoneDetection
//
//  Created by Kai on 5/11/18.
//  Copyright © 2018 Kai. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let volumeView = MPVolumeView(frame: CGRect.zero)
        for subview in volumeView.subviews {
            if let button = subview as? UIButton {
                button.setImage(nil, for: .normal)
                button.isEnabled = false
                button.sizeToFit()
            }
        }
        UIApplication.shared.windows.first?.addSubview(volumeView)
        UIApplication.shared.windows.first?.sendSubview(toBack: volumeView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch {
//            debugPrint("\(error)")
//            print("viewWillAppear")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
        do { try AVAudioSession.sharedInstance().setActive(false) }
        catch {
//            debugPrint("\(error)")
//            print("ViewWillDisappear")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
            print("got signal")
//            guard let dict = change, let temp = dict[NSKeyValueChangeKey.newKey] as? Float, temp != 0.5 else { return }
////            let systemSlider = MPVolumeView().subviews.first { (aView) -> Bool in
////                return NSStringFromClass(aView.classForCoder) == "MPVolumeSlider" ? true : false
////                } as? UISlider
////            systemSlider?.setValue(0.5, animated: false)
////            guard systemSlider != nil else { return }
//            debugPrint("Either volume button tapped.")
//
//            print("temp \(temp)")
        default: print("another key")
            break
        }
}
}
