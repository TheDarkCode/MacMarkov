//
//  ViewController.swift
//  MacMarkov
//
//  Created by Adam Boyd on 2016-03-05.
//  Copyright © 2016 Adam. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, MarkovGeneratorDelegate {

    var markov: MarkovGenerator!
    
    @IBOutlet weak var addTextButton: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var generateButton: NSButton!
    @IBOutlet weak var resultLabel: NSTextField!
    @IBOutlet weak var spinner: NSProgressIndicator!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var progressTextfield: NSTextField!
    @IBOutlet weak var progressView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.hidden = true
        self.progressView.hidden = true
        self.progressIndicator.doubleValue = 0
        self.progressIndicator.minValue = 0
        self.progressIndicator.maxValue = 100
        self.textField.enabled = false
        self.generateButton.enabled = false
        self.resultLabel.enabled = false
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    /**
     User hit the generate button, use the markov generator to make a sentence and then set the text
     
     - parameter sender: generate button
     */
    @IBAction func generateAction(sender: AnyObject) {
        self.resultLabel.stringValue = self.markov.generateSentence(self.textField.stringValue)
    }
    
    @IBAction func addTextAction(sender: AnyObject) {
        self.progressView.hidden = false
        self.spinner.hidden = false
        self.spinner.startAnimation(self)
        self.generateButton.enabled = false
        self.addTextButton.enabled = false
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.markov = MarkovGenerator()
            self.markov.delegate = self
            self.markov.addFileToGenerator("allshakespeare")
        }

    }
    
    //MARK: - MarkovGeneratorDelegate
    
    func updateProgress(progress: CGFloat) {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressTextfield.stringValue = String(format: "%.2f%", progress * 100) + "%"
            let difference = (Double(progress) * 100) - self.progressIndicator.doubleValue
            self.progressIndicator.incrementBy(difference)
        }
    }
    
    func finishedFile() {
        dispatch_async(dispatch_get_main_queue()) {
            //When done loading, stop the spinner
            self.spinner.stopAnimation(self)
            self.spinner.hidden = true
            self.progressView.hidden = true
            self.addTextButton.enabled = true
            self.textField.enabled = true
            self.generateButton.enabled = true
            self.resultLabel.enabled = true
        }
    }
}

