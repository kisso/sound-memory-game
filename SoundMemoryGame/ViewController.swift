//
//  ViewController.swift
//  SoundMemoryGame
//
//  Created by Krystof Kiss on 21/05/16.
//  Copyright © 2016 HenceApps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet var soundButton: [UIButton]!
    
    var sound1Player: AVAudioPlayer!
    var sound2Player: AVAudioPlayer!
    var sound3Player: AVAudioPlayer!
    var sound4Player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioFiles()
    }
    
    func setupAudioFiles() {
        let soundFilePath1 = NSBundle.mainBundle().pathForResource("1", ofType: "wav")
        let soundFileURL1 = NSURL(fileURLWithPath: soundFilePath1!)
        
        let soundFilePath2 = NSBundle.mainBundle().pathForResource("2", ofType: "wav")
        let soundFileURL2 = NSURL(fileURLWithPath: soundFilePath2!)
        
        let soundFilePath3 = NSBundle.mainBundle().pathForResource("3", ofType: "wav")
        let soundFileURL3 = NSURL(fileURLWithPath: soundFilePath3!)
        
        let soundFilePath4 = NSBundle.mainBundle().pathForResource("4", ofType: "wav")
        let soundFileURL4 = NSURL(fileURLWithPath: soundFilePath4!)
        
        do {
            try sound1Player = AVAudioPlayer(contentsOfURL: soundFileURL1)
            try sound2Player = AVAudioPlayer(contentsOfURL: soundFileURL2)
            try sound3Player = AVAudioPlayer(contentsOfURL: soundFileURL3)
            try sound4Player = AVAudioPlayer(contentsOfURL: soundFileURL4)
        } catch {
            print(error)
        }
    }

}
