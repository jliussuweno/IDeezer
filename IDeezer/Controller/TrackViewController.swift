//
//  TrackViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit
import AVFoundation
import AVKit

class TrackViewController: UIViewController {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    var player: AVAudioPlayer?
    var soundName: String?
    var imageURLView: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        let urlstring = soundName
        print("ini : \(String(describing: urlstring))" )
        let url = NSURL(string: urlstring!)
        print("the url = \(url!)")
//        downloadFileFromURL(url: url!)
        play(url: url!)
    }
    
//    func downloadFileFromURL(url:NSURL){
//
//        var downloadTask:URLSessionDownloadTask
//        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
////            self?.play(url: URL! as NSURL)
//        })
//
//        downloadTask.resume()
//
//    }
    
    func play(url:NSURL) {
        print("playing \(url)")

        do {
            self.player = try AVAudioPlayer(contentsOf: url as URL)
            player!.prepareToPlay()
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }

    }
    
}
