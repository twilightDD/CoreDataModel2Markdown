//
//  ViewController.swift
//  CoreDataToMD
//
//  Created by Peter Hauke on 02.06.21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var markdownTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        if let document = view.window?.windowController?.document as? Document,
           let markdown = document.markdown {
            markdownTextView.string = markdown
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            Swift.print("")
        }
    }


}

