//
//  ViewController.swift
//  Lab1
//
//  Created by Nelson Dufitimana on 26/02/2022.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
    var extraAnswer1: String?
    var extraAnswer2: String?
}

//define a custom cgColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
let customColor = UIColor(red: 128, green: 186, blue: 229)

class ViewController: UIViewController {

    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var FrontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    
    @IBOutlet weak var deleteteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    //button to remember the correct answer
    
    var correctAnswerButton: UIButton!
    
    
    
    
    
    
    //an array that holds all of our flashcards
    var flashcards = [Flashcard]()
    //track what flashcard we are showing
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20.0
        
        FrontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        
        FrontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionThree.layer.cornerRadius = 20.0
        
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionThree.layer.borderWidth = 3.0
        
        btnOptionOne.layer.borderColor = customColor.cgColor

        btnOptionTwo.layer.borderColor = customColor.cgColor
        btnOptionThree.layer.borderColor = customColor.cgColor
        readSavedFlashcards()
        if flashcards.count == 0{
           userHasNoFlashcards()
        }else{
            updateLabels()
            updateNextPrevButtons()
        }
        
        
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.translatedBy(x: 0.75, y: 0.75)
        //animate the card to show up a few seconds
        UIView.animate(withDuration: 0.6, delay: 0.60, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
            
        })
        btnOptionOne.alpha = 0.0
        btnOptionOne.transform = CGAffineTransform.identity.translatedBy(x: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.6, delay: 0.63, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.btnOptionOne.alpha = 1.0
            self.btnOptionOne.transform = CGAffineTransform.identity
            
        })
        btnOptionTwo.alpha = 0.0
        btnOptionTwo.transform = CGAffineTransform.identity.translatedBy(x: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.6, delay: 0.635, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.btnOptionTwo.alpha = 1.0
            self.btnOptionTwo.transform = CGAffineTransform.identity
            
        })
        btnOptionThree.alpha = 0.0
        btnOptionThree.transform = CGAffineTransform.identity.translatedBy(x: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.6, delay: 0.640, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.btnOptionThree.alpha = 1.0
            self.btnOptionThree.transform = CGAffineTransform.identity
            
        })
        
        
        
    }
    

    
    @IBAction func didTapOn1(_ sender: Any) {
            if btnOptionOne == correctAnswerButton{
                flipFlashcard()
            }else{
            FrontLabel.isHidden = false
            btnOptionOne.isHidden = true
        }
    }
    
    @IBAction func didTapOn2(_ sender: Any) {
        if btnOptionTwo == correctAnswerButton{
            flipFlashcard()
        }else{
            FrontLabel.isHidden = false
            btnOptionTwo.isHidden = true
        }
    }
    
    @IBAction func didTapOn3(_ sender: Any) {
        if btnOptionThree == correctAnswerButton{
            flipFlashcard()
        }else{
            FrontLabel.isHidden = false
            btnOptionThree.isHidden = true
        }
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
     
        
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //decrement index
        
        currentIndex = currentIndex - 1
        
        prev_animateCardOut()
        
        //show the question if they had just seen the answer
        if FrontLabel.isHidden == true{
            FrontLabel.isHidden = false
        }
   
        //update buttons too
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increment index
        currentIndex = currentIndex + 1
        
        //update labels
        animateCardOut()
        //hide show the question if they had just seen the answer
        if FrontLabel.isHidden == true{
            FrontLabel.isHidden = false
        }
      
        //update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Flashcard", message: "Are you sure you want to delete this flashcard?", preferredStyle: .actionSheet)
        let deleteAction  = UIAlertAction(title: "Delete", style: .destructive){action in self.deleteCurrentFlashcard()}
        
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
   
    }
    
    func deleteCurrentFlashcard(){
        //delete the current card
        flashcards.remove(at: currentIndex)
        
        //if it's the last card we just delete update the current index
        if currentIndex > flashcards.count-1{
            currentIndex = flashcards.count-1
        }
        updateLabels()
        updateNextPrevButtons()
        saveAllFlashcardsToDisk()
        
        
        //case to handle: what if they are deleting their last flaschard?
        /*
         my thinking is that we would present a special label to that tells them to press + button to add cards
         */
        
        
        
    }
    func updateFlashcard(question:String, answer:String, extraAnswer1: String, extraAnswer2: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer, extraAnswer1: extraAnswer1, extraAnswer2: extraAnswer2)
        
        if isExisting{
            flashcards[currentIndex] = flashcard
        }else{
        
            print("DEBUG: Added a Flashcard!")
            print("DEBUG: We have \(flashcards.count) flashcards")
            flashcards.append(flashcard)
            
            //update our current index
            
            currentIndex = flashcards.count - 1
            print("DEBUG: Current index \(currentIndex)")
            
            
            
           
        }
        //update buttons
        updateNextPrevButtons()
        //update labels too
        updateLabels()
        saveAllFlashcardsToDisk()
        
        
        
    }
    
    func updateNextPrevButtons(){
        //disable prev if index = 0 and next if viewing last question
        if currentIndex == flashcards.count-1{
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        if currentIndex == 0{
            prevButton.isEnabled = false
        }else{
            prevButton.isEnabled = true
        }
    }
    func updateLabels(){
 
      
        
        //update labels
        if currentIndex == -1{
            userHasNoFlashcards()

        }else{
            //get the current flashcard
            let currentFlashcard = flashcards[currentIndex]
            doSetUp()
            FrontLabel.text = currentFlashcard.question
            backLabel.text = currentFlashcard.answer
            btnOptionOne.setTitle(currentFlashcard.extraAnswer1, for: .normal)
            btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
            btnOptionThree.setTitle(currentFlashcard.extraAnswer2, for: .normal)
            
            
            //shuffle buttons
            
            let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
            let answers = [currentFlashcard.answer, currentFlashcard.extraAnswer1, currentFlashcard.extraAnswer2].shuffled()
            
            for(button, answer) in zip(buttons, answers){
                button?.setTitle(answer, for: .normal)
                //save the correct answer in the correct answer button
                if answer == currentFlashcard.answer{
                    correctAnswerButton = button
                }
            }
            
        
            
        }
        
        

        
        
    }
    
    func flipFlashcard(){
      
        UIView.transition(with: card, duration: 0.3, options:.transitionFlipFromRight, animations:{ [self] in
            if FrontLabel.isHidden==true{
                FrontLabel.isHidden = false
                
            }
            else{
                FrontLabel.isHidden=true
            }
        })
                        
    }
    func saveAllFlashcardsToDisk(){
    
        let dictionaryArray = flashcards.map{ (card) -> [String : String?] in return["question":card.question, "answer": card.answer, "extraAnswer1": card.extraAnswer1, "extraAnswer2": card.extraAnswer2]
            
        }
        
        
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("DEBUG: Flashcards saved to UserDefaults")
    }
    
    func animateCardOut(){
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        } completion: { finished in
            //update labels
            self.updateLabels()
            
            self.animateCardIn()
        }

        
    }
    func animateCardIn(){
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
            UIView.animate(withDuration: 0.3){
                self.card.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    func prev_animateCardOut(){
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        } completion: { finished in
            //update labels
            self.updateLabels()
            
            self.prev_animateCardIn()
        }

        
    }
    func prev_animateCardIn(){
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            UIView.animate(withDuration: 0.3){
                self.card.transform = CGAffineTransform.identity
            }
        }
        
    }
    func readSavedFlashcards(){
        
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]] {
            let savedCards = dictionaryArray.map{dictionary -> Flashcard in return
                Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswer1: dictionary["extraAnswer1"] ?? "Default value", extraAnswer2: dictionary["extraAnswer2"] ?? "Default value" )
            }
            flashcards.append(contentsOf: savedCards)
        }
        
        
    }
    func userHasNoFlashcards(){
        FrontLabel.text = "Press + to add a Flashcard!"
        backLabel.isHidden = true
        btnOptionOne.isHidden = true
        btnOptionTwo.isHidden = true
        btnOptionThree.isHidden = true
        prevButton.isHidden = true
        nextButton.isHidden = true
        deleteteButton.isHidden = true
        editButton.isHidden = true
        
        
    }
    func doSetUp(){
        backLabel.isHidden = false
        btnOptionOne.isHidden = false
        btnOptionTwo.isHidden = false
        btnOptionThree.isHidden = false
        prevButton.isHidden = false
        nextButton.isHidden = false
        deleteteButton.isHidden = false
        editButton.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        if segue.identifier == "EditSegue"{
            
            creationController.initialQuestion = FrontLabel.text
            creationController.initialAnswer = backLabel.text
            creationController.initExtraAnswer1 = btnOptionOne.currentTitle
            creationController.initExtraAnswer2 = btnOptionThree.currentTitle
        }
        creationController.flashcardsController = self
        
    }
    
}

