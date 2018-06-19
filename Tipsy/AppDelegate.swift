//
//  AppDelegate.swift
//  TypoSizer
//
//  Created by Adrien Leloup on 14/05/18.
//  Copyright © 2018 voidgraphics. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("tipsy-small-32"))
            button.action = #selector(showMenu(_:))
        }
        popover.contentViewController = PopoverViewController.freshController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.renderWebView(_:)), name: NSNotification.Name(rawValue: "render"), object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func showMenu(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "popover"), object: nil, userInfo: nil)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    @objc func renderWebView(_ notification: NSNotification) {
        print("render web view")
        if let vc = popover.contentViewController as! PopoverViewController? {
            print("got popover vc")
            if let data = notification.userInfo {
                if let webview = vc.webView as CustomWebView? {
                    webview.render(data["text"]! as! String, font: data["font"]! as! String, steps: data["steps"]! as! Int, base: data["base"]! as! Int, scale: (data["scale"]! as! String), isPopover: true)
                }
            }
        }
    }


}

