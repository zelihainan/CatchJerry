//
//  ViewController.swift
//  CatchJerry
//
//  Created by Zeliha İnan on 5.08.2025.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = Timer()
    var counter = 0
    var scoreCounter = 0
    var storedHighScore = 0
    var jerryTimer = Timer()
    var gameIsActive = false
    var canClick = true

    @IBOutlet weak var timerField: UILabel!
    @IBOutlet weak var scoreField: UILabel!
    @IBOutlet weak var jerryImage: UIImageView!
    @IBOutlet weak var highScoreField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storedHighScore = UserDefaults.standard.integer(forKey: "highScore")
        highScoreField.text = "High Score: \(storedHighScore)"
        
        jerryImage.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        jerryImage.addGestureRecognizer(tapGestureRecognizer)
        
        startGame()
    }
    
    @objc func handleTap() {
        if gameIsActive && canClick{
            scoreCounter += 1
            scoreField.text = "Score: \(scoreCounter)"
            canClick = false
        }
    }
    
    @objc func timerFunction() {
        counter -= 1
        timerField.text = "\(counter)"
        
        if counter == 0 {
            timer.invalidate()
            jerryTimer.invalidate()
            gameIsActive = false
            updateHighScore()
            timerField.text = "Time's Over"
            makeAlert()
        }
    }
    
    @objc func jerryMoveFunction() {
        moveJerryRandomly()
        canClick = true
    }
    
    func makeAlert() {
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: { _ in
            self.startGame()
        }))
        
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { _ in
            self.gameIsActive = false
            exit(0)
        }))
        
        present(alert, animated: true)
    }

    
    func updateHighScore() {
        if scoreCounter > storedHighScore {
            storedHighScore = scoreCounter
            UserDefaults.standard.set(scoreCounter, forKey: "highScore")
            highScoreField.text = "High Score: \(storedHighScore)"}
    }
        
    func startGame() {
        scoreCounter = 0
        scoreField.text = "Score: \(scoreCounter)"
                
        counter = 20
        timerField.text = "\(counter)"
                
        timer.invalidate()
        jerryTimer.invalidate( )
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        jerryTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(jerryMoveFunction), userInfo: nil, repeats: true)

        gameIsActive = true
    }
    
    func moveJerryRandomly() {
        
        let minX: CGFloat = 50
        let maxX: CGFloat = view.frame.width - 50
        let minY: CGFloat = view.frame.height / 3
        let maxY: CGFloat = view.frame.height * 2 / 3
        
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        UIView.animate(withDuration: 0.2) {
            self.jerryImage.center = CGPoint(x: randomX, y: randomY)
        }
    }
}

