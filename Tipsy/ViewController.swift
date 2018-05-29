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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        render()
    }

    override func controlTextDidChange(_ notification: Notification) {
//        update()
        render()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
//        update()
        render()
    }
    
    func render() {
        let data = getData()
        if data.steps == 0 { return }
        webview.render(data.text, font: data.font, steps: data.steps, base: data.base, scale: data.scale)
    }
    
    func update() {
        let data = getData()
        if data.steps == 0 { return }
        webview.update()
    }
    
    func getData() -> (base: Int, scale: String?, text: String, font: String, steps: Int) {
        let base = Int(baseField.intValue)
        let scale = scaleField.titleOfSelectedItem
        let text = sampleField.stringValue
        let font = fontField.stringValue
        let steps = Int(stepsField.intValue)
        return (base: base, scale: scale, text: text, font: font, steps: steps)
    }
    
    @IBAction func exportClicked(_ sender: Any) {
        let data = getData()
        let renderedHtml = webview.generateHtml(data.text, font: data.font, steps: data.steps, base: data.base, scale: data.scale, export: true)
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

