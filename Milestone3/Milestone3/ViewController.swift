//
//  ViewController.swift
//  Milestone3
//
//  Created by Thiago Alves on 7/22/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

// swiftlint:disable function_body_length identifier_name

import UIKit

class ViewController: UIViewController {
    var hangmanImage: UIImageView!
    var answerLabel: UILabel!
    var letterButtons = [UIButton]()

    var words = [String]()
    var solutionIndex = 0
    var rightAnswers = 0
    var wrongAnswers = 0 {
        didSet {
            hangmanImage.image = UIImage(named: "hangman\(wrongAnswers)")
        }
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        hangmanImage = UIImageView(image: UIImage(named: "hangman0"))
        hangmanImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hangmanImage)

        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 36)
        answerLabel.text = "ANSWER"
        answerLabel.textAlignment = .center
        view.addSubview(answerLabel)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            hangmanImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            hangmanImage.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            hangmanImage.heightAnchor.constraint(equalToConstant: 220),
            hangmanImage.widthAnchor.constraint(equalTo: hangmanImage.heightAnchor),

            answerLabel.topAnchor.constraint(equalTo: hangmanImage.bottomAnchor, constant: 50),
            answerLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),

            buttonsView.topAnchor.constraint(greaterThanOrEqualTo: answerLabel.bottomAnchor, constant: 50),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 250),
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50)
        ])

        // set some values for the width and height of each button
        let width = 50
        let height = 50

        // create 20 buttons as a 4x6 grid
        for row in 0..<4 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }

        // create 2 extra buttons for line 5
        for row in 4..<5 {
            for column in 2..<4 {
                let letterButton = UIButton(type: .system)
                letterButton.frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }

        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        if letterButtons.count == alphabet.count {
            for (index, letter) in alphabet.enumerated() {
                letterButtons[index].setTitle(String(letter), for: .normal)
                letterButtons[index].titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButtons[index].layer.borderWidth = 1
                letterButtons[index].layer.borderColor = UIColor.lightGray.cgColor
                letterButtons[index].addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let allWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let allWords = try? String(contentsOf: allWordsURL) {
                words = allWords.components(separatedBy: "\n")
            }
        }

        if words.isEmpty {
            words = ["silkworm"]
        }

        for i in 0..<words.count {
            words[i] = words[i].trimmingCharacters(in: .newlines).uppercased()
        }

        loadGame()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }

        sender.isEnabled = false

        if words[solutionIndex].contains(buttonTitle) {
            var splitAnswer = answerLabel.text?.components(separatedBy: " ")

            for (index, letter) in words[solutionIndex].enumerated() {
                if buttonTitle == String(letter) {
                    splitAnswer?[index] = buttonTitle
                    rightAnswers += 1
                }
            }

            answerLabel.text = splitAnswer?.joined(separator: " ")

            if rightAnswers == words[solutionIndex].count {
                let ac = UIAlertController(title: "Well done!",
                                           message: "The correct solution was \(words[solutionIndex]).",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: loadGame))
                present(ac, animated: true)
            }
        } else {
            wrongAnswers += 1

            if wrongAnswers == 7 {
                let ac = UIAlertController(title: "Oh no!",
                                           message: "The correct solution was \(words[solutionIndex]).",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: loadGame))
                present(ac, animated: true)
            }
        }
    }

    @objc func loadGame(action: UIAlertAction! = nil) {
        var answer = ""

        solutionIndex = Int.random(in: 0..<words.count)
        rightAnswers = 0
        wrongAnswers = 0

        print(words[solutionIndex])

        for _ in 0..<words[solutionIndex].count {
            answer += "_ "
        }

        answerLabel.text = answer.trimmingCharacters(in: .whitespaces)

        for button in letterButtons {
            button.isEnabled = true
        }
    }

}
