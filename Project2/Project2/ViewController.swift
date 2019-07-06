//
//  ViewController.swift
//  Project2
//
//  Created by Thiago Alves on 7/6/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func setTitle() {
        title = "Flag \(totalQuestions) of 10: \(countries[correctAnswer]) (Score: \(score))"
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0].lowercased()), for: .normal)
        button2.setImage(UIImage(named: countries[1].lowercased()), for: .normal)
        button3.setImage(UIImage(named: countries[2].lowercased()), for: .normal)
        
        totalQuestions += 1
        setTitle()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title = "Wrong! That’s the flag of \(countries[sender.tag])!"
            score -= 1
        }
        
        setTitle()
        
        let ac = UIAlertController(title: title, message: "Your current score is \(score).", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default) {
            action in
            if self.totalQuestions < 10 {
                self.askQuestion()
            } else {
                let ac = UIAlertController(title: "Game Over!", message: "Your final score is \(self.score).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: self.askQuestion))
                self.score = 0
                self.totalQuestions = 0
                self.present(ac, animated: true)
            }
        })
        
        present(ac, animated: true)
    }
    
}

