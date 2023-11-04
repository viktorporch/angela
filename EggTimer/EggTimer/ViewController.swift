//
//  ViewController.swift
//  EggTimer
//
//  Created by Victor on 04.11.2023
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var softButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    let player = AVPlayer()
    
    enum EggsTime: Int {
        case soft(Int) = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        let time: Double
        let message: String
        guard let eggsTime = EggsTime(rawValue: sender.tag - 1) else { return }
        switch eggsTime {
        case .soft:
            time = 2.0
            message = "Soft"
        case .medium:
            time = 4.0
            message = "Medium"
        case .hard:
            time = 6.0
            message = "Hard"
        }
        
        sentenceLabel.text = message
        progressBar.progress = 0.0
        softButton.isEnabled = false
        mediumButton.isEnabled = false
        hardButton.isEnabled = false
        
        var count = 0.0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            count += 1
            self?.progressBar.progress =  Float(count) / Float(time)
            print(count)
            if count >= time {
                self?.sentenceLabel.text = "DONE!"
                self?.softButton.isEnabled = true
                self?.mediumButton.isEnabled = true
                self?.hardButton.isEnabled = true
                
                guard let soundUrl = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
                self?.player.replaceCurrentItem(with: AVPlayerItem(url: soundUrl))
                self?.player.play()
                
                timer.invalidate()
            }
        }
    }


}

