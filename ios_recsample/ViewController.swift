//
//  ViewController.swift
//  ios_recsample
//
//  Created by 佐野正和 on 2016/07/16.
//  Copyright © 2016年 佐野正和. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var recBtn: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRecording()
        setupAudioRecorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: action
    
    
    @IBAction func recBtnTapped(sender: UIButton) {
        print("do rec..")
        audioRecorder?.record()
    }
    
    @IBAction func recStopBtnTapped(sender: UIButton) {
        print("stop rec..")
        audioRecorder?.stop()
    }

    @IBAction func startBtnTapped(sender: UIButton) {
        playRecFile()
    }
    
    @IBAction func stopBtnTapped(sender: UIButton) {
        stopRecFile()
    }
    
    
    
    // MARK: private func
    
    private func initRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch  {
            // エラー処理
            fatalError("カテゴリ設定失敗")
        }
        
        do {
            try session.setActive(true)
        } catch {
            fatalError("session有効化失敗")
        }
    }
    
    private func setupAudioRecorder() {
        
        let recURL = getRecURL()
        // 録音設定
        let recordSettings: [String: AnyObject] =
            [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0]
        do {
            audioRecorder = try AVAudioRecorder(URL: recURL, settings: recordSettings)
        } catch {
            audioRecorder = nil
        }
    }
    
    private func getRecURL() -> NSURL {
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
        print("dirURL : \(dirURL.absoluteString)")
        let fileName = "recording.caf"
        return dirURL.URLByAppendingPathComponent(fileName)
    }
    
    // DocumentsのURLを取得
    private func documentsDirectoryURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                                                                   inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if urls.isEmpty {
            fatalError("URLs for directory are empty.")
        }
        return urls[0]
    }
    
    private func playRecFile() {
        do {
            let recURL = getRecURL()
            audioPlayer = try AVAudioPlayer(contentsOfURL: recURL)
            if let audioPlayer = audioPlayer {
                audioPlayer.prepareToPlay()
            }
        } catch {
            print("Error")
        }
        
        if let audioPlayer = audioPlayer {
            audioPlayer.play()
        }
    }
    
    private func stopRecFile() {
        if ((audioPlayer?.playing) != nil) {
            audioPlayer?.stop()
        }
    }
}

