//
//  mainVC.swift
//  tryctionary
//
//  Created by Popolo on 24/07/16.
//  Copyright © 2016 Andrea Asioli. All rights reserved.
//

import UIKit
import QuartzCore

class MainVC: UIViewController, UITextFieldDelegate {
    
    var selectedString = String()
    var parole = [String]()
    var upperLabel = UILabel()
    var centralText = UITextField()
    var lowerLabel = UILabel();
    let height: CGFloat = 40;
    let margin:CGFloat = 40;
    let textColor = UIColor.whiteColor()
    let textbackground = UIColor.lightGrayColor()
    let textFont = UIFont.systemFontOfSize(40/1.5, weight: UIFontWeightBold)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.darkGrayColor();
        do {
            parole = try linesFromResource("it_IT.dic")
            print(parole.count)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch let error {
            print(error)
        }
        
        chooseSecretWord()
        
        
        
        
        upperLabel.frame = CGRectMake(margin, margin, self.view.frame.size.width-2*margin, height);
        preprareLabel(upperLabel,text: "???????")
        upperLabel.font = textFont
        self.view.addSubview(upperLabel);
        
        
        centralText.frame = CGRectMake(margin, 2*margin+upperLabel.frame.size.height, self.view.frame.size.width-2*margin, height);
        centralText.backgroundColor = UIColor.greenColor();
        centralText.textAlignment = NSTextAlignment.Center
        centralText.layer.cornerRadius = height/2
        centralText.clipsToBounds = true
        centralText.textColor = textColor
        centralText.font = textFont
        centralText.becomeFirstResponder();
        centralText.delegate = self
        centralText.autocorrectionType = UITextAutocorrectionType.No
        centralText.keyboardType = UIKeyboardType.Alphabet
        centralText.keyboardAppearance = UIKeyboardAppearance.Dark
        centralText.tintColor = textColor
        self.view.addSubview(centralText);
        
        
        lowerLabel.frame = CGRectMake(margin, 3*margin+upperLabel.frame.size.height+centralText.frame.size.height, self.view.frame.size.width-2*margin, height);
        lowerLabel.backgroundColor = UIColor.greenColor();
        lowerLabel.text = "??????"
        lowerLabel.textAlignment = NSTextAlignment.Center
        lowerLabel.layer.cornerRadius = height/2
        lowerLabel.clipsToBounds = true
        lowerLabel.textColor = textColor
        lowerLabel.font = textFont
        self.view.addSubview(lowerLabel);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func linesFromResource(fileName: String) throws -> [String] {
        
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil) else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: [ NSFilePathErrorKey : fileName ])
        }
        let content = try String(contentsOfFile: path, encoding: NSASCIIStringEncoding)
        var stringArray = [String]()
        for string in content.componentsSeparatedByString("\n") {
            let parola: String
            if string.containsString("/") {
                parola = string.substringToIndex(string.rangeOfString("/")!.startIndex)
            }else{
                parola = string
            }
            if parola.lowercaseString == parola {
                stringArray.append(parola)
            }
            
        }
        return stringArray
    }
    
    func chooseSecretWord() {
        let random = arc4random_uniform(UInt32(parole.count))
        selectedString = parole[NSInteger(random)]
       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
       let typedText = centralText.text
       let pippo = typedText!.uppercaseString.compare(selectedString.uppercaseString)
        switch pippo {
        case NSComparisonResult.OrderedSame:
            print("stessa parola")
            upperLabel.text = "Yeah!"
            lowerLabel.text = "Hai vinto!"
        case NSComparisonResult.OrderedDescending:
            print("viene dopo")
            let newlabel = UILabel()
            newlabel.frame = centralText.frame
            preprareLabel(newlabel,text:typedText)
            self.view.addSubview(newlabel)
            UIView.animateWithDuration(0.5, animations: {
                self.lowerLabel.alpha = 0
                newlabel.frame = self.lowerLabel.frame
                }, completion: { (finished) in
                    self.lowerLabel = newlabel
            })
            
            centralText.text = ""
        case NSComparisonResult.OrderedAscending:
              print("viene prima")
              let newlabel = UILabel()
              newlabel.frame = centralText.frame
              preprareLabel(newlabel,text:typedText)
              self.view.addSubview(newlabel)
              UIView.animateWithDuration(0.5, animations: {
                self.upperLabel.alpha = 0
                newlabel.frame = self.upperLabel.frame
                }, completion: { (finished) in
                    self.upperLabel = newlabel
              })
              
              centralText.text = ""
            
        }

        return true
        
    }
    
    func preprareLabel(label:UILabel,text:String?) {
        label.backgroundColor = UIColor.greenColor();
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.layer.cornerRadius = height/2
        label.clipsToBounds = true
        label.textColor = textColor
        label.font = textFont
    }

}
