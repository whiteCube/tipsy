//
//  ViewController.swift
//  TypoSizer
//
//  Created by Adrien Leloup on 14/05/18.
//  Copyright © 2018 voidgraphics. All rights reserved.
//

import Cocoa
import WebKit

@IBDesignable class ViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet var baseField: NSTextField!
    @IBOutlet var scaleField: NSPopUpButton!
    @IBOutlet var sampleField: NSTextField!
    @IBOutlet var fontField: NSTextField!
    @IBOutlet var webview: CustomWebView!
    @IBOutlet var stepsField: NSTextField!
    
    
    
//    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
//    let popover = NSPopover()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.showPopover), name: NSNotification.Name(rawValue: "popover"), object: nil)
        
        render()
        
//        if let button = statusItem.button {
//            button.image = NSImage(named:NSImage.Name("tipsy-small-32"))
//            button.action = #selector(showMenu(_:))
//        }
//        popover.contentViewController = PopoverViewController.freshController()
    }

    override func controlTextDidChange(_ notification: Notification) {
        //update()
        render()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        //update()
        render()
    }
    
    func render() {
        let data = getData()
        if data.steps == 0 { return }
        
        webview.render(data.text, font: data.font, steps: data.steps, base: data.base, scale: data.scale, isPopover: false)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "render"), object: nil, userInfo: ["base": data.base, "font": data.font, "steps": data.steps, "scale": data.scale, "text": data.text])
        
//        let appDelegate = NSApplication.shared.delegate as! AppDelegate
//        if let popoverVC = appDelegate.popover.contentViewController as! PopoverViewController? {
//            popoverVC.webView.render(data.text, font: data.font, steps: data.steps, base: data.base, scale: data.scale)
//        }
        
    }
    
    func update() {
        let data = getData()
        if data.steps == 0 { return }
        webview.update()
    }
    
    func getData() -> RenderData {
        let base = Int(baseField.intValue)
        let scale = scaleField.titleOfSelectedItem
        let text = sampleField.stringValue
        let font = fontField.stringValue
        let steps = Int(stepsField.intValue)
        
        return RenderData(base, scale!, text, font, steps)
    }
    
    @objc func showPopover() {
        render()
    }
    
    @IBAction func exportClicked(_ sender: Any) {
        let data = getData()
        let renderedHtml = webview.generateHtml(data.text, font: data.font, steps: data.steps, base: data.base, scale: data.scale, export: true, isPopover: false)
        if renderedHtml != "" {
            let save = NSSavePanel()
            save.allowedFileTypes = ["html"]
            save.begin { (result) -> Void in
                if result == NSApplication.ModalResponse.OK {
                    let filename = save.url
                    
                    do {
                        try renderedHtml.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        // failed to write file (bad permissions, bad filename etc.)
                        print("error while writing file")
                    }
                    
                }
            }
        }
    }

}

