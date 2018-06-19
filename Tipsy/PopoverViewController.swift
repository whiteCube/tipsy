//
//  PopoverViewController.swift
//  Tipsy
//
//  Created by Adrien Leloup on 29/05/18.
//  Copyright © 2018 voidgraphics. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
    @IBOutlet var webView: CustomWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: Storyboard instantiation
    static func freshController() -> PopoverViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PopoverViewController")
        //3.
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Why cant i find PopoverViewController? - Check Main.storyboard")
        }
        return vc
    }
    
}
