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
    
    var playList = [Int]()
    var currentItem = 0
    var numberOfTaps = 0
    var readyForUser = false
    var level = 1
    var gameOver = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupAudioFiles()
        disableButtons()
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
            sound1Player.prepareToPlay()
            try sound2Player = AVAudioPlayer(contentsOfURL: soundFileURL2)
            sound2Player.prepareToPlay()
            try sound3Player = AVAudioPlayer(contentsOfURL: soundFileURL3)
            sound3Player.prepareToPlay()
            try sound4Player = AVAudioPlayer(contentsOfURL: soundFileURL4)
            sound4Player.prepareToPlay()
            
        } catch {
            
            print(error)
            
        }
        
        sound1Player.delegate = self
        sound2Player.delegate = self
        sound3Player.delegate = self
        sound4Player.delegate = self
        
        sound1Player.numberOfLoops = 0
        sound2Player.numberOfLoops = 0
        sound3Player.numberOfLoops = 0
        sound4Player.numberOfLoops = 0
    }
    
    @IBAction func soundButtonPressed(sender: AnyObject) {
        
        if readyForUser {
            let button = sender as! UIButton
            
            switch button.tag {
            case 1:
                stopSound()
                sound1Player.play()
                checkIfCorrect(1)
                break
            case 2:
                stopSound()
                sound2Player.play()
                checkIfCorrect(2)
                break
            case 3:
                stopSound()
                sound3Player.play()
                checkIfCorrect(3)
                break
            case 4:
                stopSound()
                sound4Player.play()
                checkIfCorrect(4)
                break
            default:
                break
            }
        }
        
    }
    
    func stopSound() {
        if sound1Player.playing || sound2Player.playing || sound3Player.playing || sound4Player.playing {
            sound1Player.stop()
            sound1Player.currentTime = 0
            sound2Player.stop()
            sound2Player.currentTime = 0
            sound3Player.stop()
            sound3Player.currentTime = 0
            sound4Player.stop()
            sound4Player.currentTime = 0
        }
    }
    
    @IBAction func startGame(sender: AnyObject) {
        gameOver = false
        levelLabel.text = "Level 1"
        disableButtons()
        let randomNumber = Int(arc4random_uniform(4) + 1)
        playList.append(randomNumber)
        startGameButton.hidden = true
        playNextItem()
        
    }
    
    func checkIfCorrect(buttonPressed: Int) {
        if buttonPressed == playList[numberOfTaps] {
            if numberOfTaps == playList.count - 1 {
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(NSEC_PER_SEC))
                
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.nextRount()
                })
            }
            numberOfTaps += 1
        } else { //Game Over
            resetGame()
            gameOver = true
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        resetButtonHighlights()
        if currentItem <= playList.count - 1 {
            playNextItem()
        } else {
            readyForUser = true
            resetButtonHighlights()
            
            if !gameOver {
                enableButtons()
            }
        }
        
    }
    
    func resetGame() {
        level = 1
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        playList = []
        levelLabel.text = "GAME OVER"
        startGameButton.hidden = false
        disableButtons()
    }
    
    func nextRount() {
        
        level += 1
        levelLabel.text = "Level \(level)"
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        disableButtons()
        
        let randomNumber = Int(arc4random_uniform(4) + 1)
        playList.append(randomNumber)
        
        playNextItem()
    }
    
    func playNextItem() {
        
        let selectedItem = playList[currentItem]
        
        switch selectedItem {
        case 1:
            highlightButtonWithTag(1)
            sound1Player.play()
            break
        case 2:
            highlightButtonWithTag(2)
            sound2Player.play()
            break
        case 3:
            highlightButtonWithTag(3)
            sound3Player.play()
            break
        case 4:
            highlightButtonWithTag(4)
            sound4Player.play()
            break
        default:
            break
        }
        
        currentItem += 1
        
    }
    
    func highlightButtonWithTag(tag: Int) {
        
        switch tag {
        case 1:
            soundButton[tag - 1].setImage(UIImage(named: "redPressed"), forState: .Normal)
            break
        case 2:
            soundButton[tag - 1].setImage(UIImage(named: "yellowPressed"), forState: .Normal)
            break
        case 3:
            soundButton[tag - 1].setImage(UIImage(named: "bluePressed"), forState: .Normal)
            break
        case 4:
            soundButton[tag - 1].setImage(UIImage(named: "greenPressed"), forState: .Normal)
            break
        default:
            break
        }
        
    }
    
    func resetButtonHighlights() {
        soundButton[0].setImage(UIImage(named: "red"), forState: .Normal)
        soundButton[1].setImage(UIImage(named: "yellow"), forState: .Normal)
        soundButton[2].setImage(UIImage(named: "blue"), forState: .Normal)
        soundButton[3].setImage(UIImage(named: "green"), forState: .Normal)
    }
    
    func disableButtons() {
        for button in soundButton {
            button.userInteractionEnabled = false
        }
    }
    
    func enableButtons() {
        for button in soundButton {
            button.userInteractionEnabled = true
        }
    }
    

}
