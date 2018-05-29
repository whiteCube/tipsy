//
//  WebViewController.swift
//  Tipsy
//
//  Created by Adrien Leloup on 15/05/18.
//  Copyright © 2018 voidgraphics. All rights reserved.
//

import Cocoa
import WebKit

class CustomWebView: WKWebView {
    
    var htmlTemplate: String? = nil
    let scales: [String: Double] = [
        "1.618 — Golden Ratio": 1.61803398875,
        "1.500 — Perfect Fifth": 1.5,
        "1.414 — √2": 1.41421356237,
        "1.570 — π / 2": 1.57079632679,
        "2.718 — e": 2.71828182846
    ]
    
    func update() {
        var jsString = "updateSizes(["
        jsString = jsString + "{selector: '.h1', size: 14}"
        jsString = jsString + "])"
        
        self.evaluateJavaScript(jsString)
    }
    
    func render(_ text: String, font: String, steps: Int, base: Int, scale: String?) {
        let html = generateHtml(text, font: font, steps: steps, base: base, scale: scale, export: false)
        loadHTMLString(html, baseURL: nil)
    }
    
    func loadHtmlString() -> String? {
        if let filepath = Bundle.main.path(forResource: "tipsy", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                print("could not read contents of tipsy.html")
                return nil
            }
        } else {
            print("tipsy.html file not found")
            return nil
        }
    }
    
    func getScaleDouble(_ scale: String?) -> Double {
        guard let unwrapped = scale else { return 1.61803398875 }
        return scales[unwrapped] ?? 1.61803398875
    }
    
    func generateHtml(_ text: String, font: String, steps: Int, base: Int, scale: String?, export: Bool) -> String {
        var template = loadHtmlString() ?? ""
        let scaleDouble = getScaleDouble(scale)
        var string = ""
        let steps = steps + 1
        
        string = string + "body { font-family: sans-serif; }"
        string = string + "body { font-family: \(font), sans-serif; }"
        
        for i in 1...steps{
            // Double the index so we have more variation between each item
            let j = i == 1 ? 1 : i * 2
            
            // $base * pow($ratio, ($n / $steps) // taken from typs by hupkens
            let size = Double(base) * pow(scaleDouble, (Double(j - 1) / Double(steps)))
            let size2 = Double(base) * pow(scaleDouble, (Double(-(j)) / Double(steps)))
            string = string + ".h\(i) { font-size: \(size)px; } .h\(i):before { content: '\(size.clean)px '; }"
            string = string + ".h-\(i) { font-size: \(size2)px; } .h-\(i):before { content: '\(size2.clean)px '; }"
        }
        
        template = template.replacingOccurrences(of: "/* STYLES */", with: string)
        
        string = ""
        
        for i in 0..<steps {
            string = string + "<p class=\"h h\(abs(i - steps))\">\(text)</p>"
        }
        
        for i in 1..<steps {
            string = string + "<p class=\"h h-\(i + 1)\">\(text)</p>"
        }
        
        if export {
            string = string + generateExportDataBar(font: font, base: base, scale: scale)
            string = string + "<p class=\"tipsy-signature\">Exported from Tipsy</p>"
        }
        
        template = template.replacingOccurrences(of: "<!-- ELEMENTS -->", with: string)
        
        return template
    }
    
    func generateExportDataBar(font: String, base: Int, scale: String?) -> String {
        var string = "<div class=\"tipsy-data\">"
        string = string + "<div class=\"tipsy-data__item\">"
        string = string + "<em class=\"tipsy-data__title\">Font</em>"
        string = string + "<p class=\"tipsy-data__value\">\(font)</p>"
        string = string + "</div>"
        string = string + "<div class=\"tipsy-data__item\">"
        string = string + "<em class=\"tipsy-data__title\">Base font size</em>"
        string = string + "<p class=\"tipsy-data__value\">\(base)</p>"
        string = string + "</div>"
        string = string + "<div class=\"tipsy-data__item\">"
        string = string + "<em class=\"tipsy-data__title\">Scale</em>"
        string = string + "<p class=\"tipsy-data__value\">\(scale ?? "Error")</p>"
        string = string + "</div>"
        string = string + "</div>"
        
        return string
    }
    
}
