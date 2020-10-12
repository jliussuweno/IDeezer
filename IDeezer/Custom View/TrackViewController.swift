//
//  TrackViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit
import AVFoundation
import AVKit

class PlayViewController: UIViewController {

    var player: AVAudioPlayer?
    var soundName = ""
    var imageURLView = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player!.play()
    }
}
