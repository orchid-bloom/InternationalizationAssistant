//
//  ViewController.swift
//  Splice
//
//  Created by Tema.Tian on 2021/3/27.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var backgroudView: NSView!
  @IBOutlet weak var processingText: NSScrollView!
  @IBOutlet weak var doneText: NSScrollView!
  @IBOutlet weak var parsingButton: NSButton!
  @IBOutlet weak var copyButton: NSButton!
  @IBOutlet var processingInput: NSTextView!
  @IBOutlet var doneInput: NSTextView!
  @IBOutlet weak var prefixTextField: NSTextField!
  @IBOutlet weak var copySuccessLabel: NSTextField!
  @IBOutlet weak var capitalizedButton: NSButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    parsingButton.action = #selector(parsingText)
    copyButton.action = #selector(copyText)
    doneInput.font = NSFont.systemFont(ofSize: 14)
    processingInput.font = NSFont.systemFont(ofSize: 14)
    prefixTextField.font = NSFont.systemFont(ofSize: 14)
  }

  @objc func parsingText() {
    let originString = processingInput.string
    var sting = processingInput.string
    sting = sting.replacePattern(pattern: "？")
    sting = sting.replacePattern(pattern: "?")
    sting = sting.replacePattern(pattern: ".")
    sting = sting.replacePattern(pattern: "。")
    sting = sting.replacePattern(pattern: ",", replaceWith: " ")
    sting = sting.replacePattern(pattern: "，", replaceWith: " ")
    var splitArray = [String]()
    if capitalizedButton.state == .on {
      splitArray = sting.split(separator: " ").map { $0.capitalized }
    } else {
      splitArray = sting.split(separator: " ").map({ String($0).lowercased() })
    }
    let parsingResult = splitArray.joined(separator: "_")
    if prefixTextField.stringValue.isEmpty {
      doneInput.string = """
      "\(parsingResult)" = "\(originString)";
      """
      return
    }
    if capitalizedButton.state == .on {
      doneInput.string = """
      "\(prefixTextField.stringValue.capitalized)_\(parsingResult)" = "\(originString)";
      """
      return
    }
    doneInput.string = """
    "\(prefixTextField.stringValue)_\(parsingResult)" = "\(originString)";
    """
  }

  @objc func copyText() {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(doneInput.string, forType: .string)
    NSPasteboard.general.string(forType: .string)
    copySuccessLabel.stringValue = "Copy Success"
    copySuccessLabel.isHidden = false
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
      self.copySuccessLabel.isHidden = true
    }
  }
}

extension String {
  func replacePattern(pattern: String, replaceWith: String = "") -> String {
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .useUnicodeWordBoundaries, .useUnixLineSeparators, .anchorsMatchLines, .dotMatchesLineSeparators, .ignoreMetacharacters, .allowCommentsAndWhitespace])
      let range = NSMakeRange(0, self.count)
      return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
    } catch {
      return self
    }
  }
}
