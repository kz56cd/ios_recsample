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
        
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
        print("dirURL : \(dirURL.absoluteString)")
        
        let fileName = "recording.caf"
        let recordingsURL = dirURL.URLByAppendingPathComponent(fileName)
        
        // 録音設定
        let recordSettings: [String: AnyObject] =
            [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: recordingsURL, settings: recordSettings)
        } catch {
            audioRecorder = nil
        }
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
}

