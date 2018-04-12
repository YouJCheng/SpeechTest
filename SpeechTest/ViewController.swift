//
//  ViewController.swift
//  SpeechTest
//
//  Created by Yu-J.Cheng on 2018/3/31.
//  Copyright © 2018年 YuChienCheng. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var transcriptionTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.isHidden = true
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }

    @IBAction func transcribeBtnPress(_ sender: UIButton) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        requestSpeechAuth()
    }


    private func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { (authStates) in
            if authStates == SFSpeechRecognizerAuthorizationStatus.authorized { 
                if let path = Bundle.main.path(forResource: "test", ofType: "m4a") {
                    let url = URL(fileURLWithPath: path)
                    do {
                        let sound = try AVAudioPlayer(contentsOf: url)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    } catch {
                        print("something wrong")
                    }
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: url)
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        if let error = error {
                            print(error.localizedDescription)

                        } else {
                            DispatchQueue.main.async {
                                self.transcriptionTextView.text = result?.bestTranscription.formattedString
                            }

                        }
                    })
                }

            }
        }
    }
}


