//
//  Model.swift
//  Quizler
//
//  Created by Victor on 11.11.2023.
//

import Foundation

struct Model {
    let questions = [
        Question(q: "Which is the largest organ in the human body?", a: ["Heart", "Skin", "Large Intestine"], correctAnswer: "Skin"),
        Question(q: "Five dollars is worth how many nickels?", a: ["25", "50", "100"], correctAnswer: "100"),
        Question(q: "What do the letters in the GMT time zone stand for?", a: ["Global Meridian Time", "Greenwich Mean Time", "General Median Time"], correctAnswer: "Greenwich Mean Time"),
        Question(q: "What is the French word for 'hat'?", a: ["Chapeau", "Écharpe", "Bonnet"], correctAnswer: "Chapeau"),
        Question(q: "In past times, what would a gentleman keep in his fob pocket?", a: ["Notebook", "Handkerchief", "Watch"], correctAnswer: "Watch"),
        Question(q: "How would one say goodbye in Spanish?", a: ["Au Revoir", "Adiós", "Salir"], correctAnswer: "Adiós"),
        Question(q: "Which of these colours is NOT featured in the logo for Google?", a: ["Green", "Orange", "Blue"], correctAnswer: "Orange"),
        Question(q: "What alcoholic drink is made from molasses?", a: ["Rum", "Whisky", "Gin"], correctAnswer: "Rum"),
        Question(q: "What type of animal was Harambe?", a: ["Panda", "Gorilla", "Crocodile"], correctAnswer: "Gorilla"),
        Question(q: "Where is Tasmania located?", a: ["Indonesia", "Australia", "Scotland"], correctAnswer: "Australia"),
    ]
    
    private var count = 0
    var score = 0
    var progress = 0.0
    var currentQuestion: Question?
    
    mutating func newGame() {
        score = 0
        count = 0
        progress = 0.0
    }
    
    mutating func answer(answerIndex value: Int) -> Bool {
        guard let currentQuestion = currentQuestion else {
            return false
        }
        progress += 1.0 / Double(questions.count)
        print(currentQuestion.a[value])
        if currentQuestion.correctAnswer == currentQuestion.a[value] {
            score += 1
            return true
        }
        score -= 1
        return false
    }
}

extension Model: Sequence, IteratorProtocol {
    typealias Element = Question
    mutating func next() -> Question? {
        if count < questions.count {
            defer { count += 1}
            currentQuestion = questions[count]
            return currentQuestion
        }
        currentQuestion = nil
        return currentQuestion
    }
}
