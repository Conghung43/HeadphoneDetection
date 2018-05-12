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
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var pause: UIButton!
    
    
    var player : AVAudioPlayer!
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
        soundBoeing()
        
    }
    func soundBoeing () {
        let path = Bundle.main.path(forResource: "CrimsonFly-V.A-3223140", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch let error as NSError {
            print("co loi \(error.description)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch {
                        debugPrint("\(error)")
            
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        
        print("viewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
        do { try AVAudioSession.sharedInstance().setActive(false) }
        catch {
            //            debugPrint("\(error)")
            
        }
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        resignFirstResponder()
        
        print("ViewWillDisappear")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
                        guard let dict = change, let temp = dict[NSKeyValueChangeKey.newKey] as? Float, temp != 0.5 else { return }
                        let systemSlider = MPVolumeView().subviews.first { (aView) -> Bool in
                            return NSStringFromClass(aView.classForCoder) == "MPVolumeSlider" ? true : false
                            } as? UISlider
                        systemSlider?.setValue(0.5, animated: false)
                        guard systemSlider != nil else { return }
            print(temp)
            if temp > 0.5 {
                plus.backgroundColor = UIColor.white
                minus.backgroundColor = UIColor.black
                pause.backgroundColor = UIColor.black
            }
            else {
                plus.backgroundColor = UIColor.black
                minus.backgroundColor = UIColor.white
                pause.backgroundColor = UIColor.black
            }
        default: print("another key")
            break
        }
    }
    override func remoteControlReceived(with event: UIEvent?) {
        //let signal = event!.subtype
        plus.backgroundColor = UIColor.black
        minus.backgroundColor = UIColor.black
        pause.backgroundColor = UIColor.white
    }
}
