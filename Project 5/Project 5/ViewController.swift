//
//  ViewController.swift
//  Project 5
//
//  Created by Adrian McDaniel on 2/9/17.
//  Copyright © 2017 Adrian McDaniel. All rights reserved.
//
import GameplayKit
import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        //adding a textField to the alert
        ac.addTextField()
        
        //TRAILING CLOSURE - everything before "in" describes the closure.  everything after "in" is the closure
        //unowned is like weak accept it assumes the reference will never be nil so doesn't need unwrapping
        //using "unowned" because "self" is captured in the closure.  Use this or "weak because you don't want a strong reference of the ViewController in the closer
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            
            //force unwrapped because we know we have a textField inside the optional array of textFields in an AlertController
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    //might need to fix method.  When answer is right it does not append to usedWords
    func submit(answer: String) {
        //lowercased the text for answer
        let lowerAnswer = answer.lowercased()
        
        
        let errorTitle: String
        let errorMessage: String
        
        //if it is a word that can be created out of the title word
        if isPossible(word: lowerAnswer) {
            
            //if it hasn't been used yet
            if isOriginal(word: lowerAnswer) {
                
                //if it is a real word
                if isReal(word: lowerAnswer) {
                    
                    //instead of tableView.reloadData, we insert a row at the top of the tableView to make it look better visually and make the tableViewController do less work
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath],
                                         with: .automatic)
                    //if the user has a correct answer the call to return will exit the method immediately
                    return
                } else {
                    //else for isPossible
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                //else for isOriginal
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            //else for isReal
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
        }
        let ac = UIAlertController(title: errorTitle, message:
            errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        
        //assigned the optional String "title" in lowercased form to the tempWord variable
        var tempWord = title!.lowercased()
        
        //for in loop to go over every letter in the word
        for letter in word.characters {
            
            
            //had to turn letter from a character to a string to see if it is within the range of the tempWord  
            //each letter is then removed to make sure it is not counted twice.  If any letter isn't found then return false
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    func isOriginal(word: String) -> Bool {
        
        //returns true or false if usedWords does NOT contain the word
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        //UITextChecker checks for spelling errors
        let checker = UITextChecker()
        
        //getting the range of the word from 0 to the count of the word
        //NOTE: word.utf16 used because of a n annoying backwards compatibility quirk: Swift’s strings natively store international characters as individual characters, e.g. the letter “é” is stored as precisely that. However, UIKit was written in Objective-C before Swift’s strings came along, and it uses a different character system called UTF-16 – short for 16-bit Unicode Transformation Format - where the accent and the letter are stored separately.
        
        //when you’re working with UIKit, SpriteKit, or any other Apple framework, use utf16.count
        let range = NSMakeRange(0, word.utf16.count)
        
        //checks the range of the word for spelling errors using the english language
        //rangeOfMisspelledWord uses NSRange - can use to tell where the spelling error occured
        let misspelledRange = checker.rangeOfMisspelledWord(in:
            word, range: range, startingAt: 0, wrap: false, language: "en")
        
        //location is the specific area where the spelling error occured and is a boolean.  NSNotFound is a boolean as well saying that the word is spelled correctly
        return misspelledRange.location == NSNotFound
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        
        //looks for the path of the file "start" of type "txt" which we added to our resources
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            
            //tries to create a string out of the text in the "start.txt" file
            if let startWords = try? String(contentsOfFile:
                startWordsPath) {
                
                //turns startWords into an array by separating a long string at each newline ("/n") into multiple strings that are components of this new array and assigning it to allWords
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        
        //shuffles the allWords array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in:
            allWords) as! [String]
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

