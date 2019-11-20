//
//  ViewController.swift
//  PBETest2
//
//  Created by boy setiawan on 26/09/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        
        
    }

    @IBOutlet weak var key: UITextField!
    
    @IBOutlet weak var reply: UITextField!
    
    @IBOutlet weak var result: UITextField!
    @IBAction func process(_ sender: UIButton) {
        
        let plain = "PlainText"
        let plainData = plain.data(using: String.Encoding.ascii)
               
               DESEncryptor.keyString = "SecretKey"
               let encryptedData = DESEncryptor.encryptData(plainData)
               guard let encrypted = encryptedData?.base64EncodedString() else { return }
               print("Encrypted Text = \(encrypted)")
              
               let decryptedData = DESEncryptor.decryptData(encryptedData)
               let strOrigional = String(decoding: decryptedData!, as: UTF8.self)
               print("Decrypted Text = \(strOrigional)")
               
               let encryptedText = DESEncryptor.encryptBase64String(plain, separateLines: false)
               print("Encrypted Text = \(encryptedText!)")
               
               let decryptedText = DESEncryptor.decryptBase64String(encryptedText!)
               print("Decrypted Text = \(decryptedText!)")
        let mystring: String = String(decryptedText!.utf8)
        print("Decrypted Text = \(mystring)")
               
               //let decryptedText = DESEncryptor.decryptBase64String(encryptedText!, keyString: DESEncryptor.keyString)
               //let encryptedReply = "ro4IIvIy1eiPKBbc93HLYZ1v/pacqSIbEPwpimblJ3k="
        let encryptedReply = self.reply.text!
            
        let key = self.key.text!
               DESEncryptor.keyString = key
               let decryptedReply = DESEncryptor.decryptBase64String(encryptedReply)
               
               guard let decryptedreply = decryptedReply else {
                   return
               }
               print("Decrypted Text = \(decryptedreply)")
               DESEncryptor.keyString = decryptedreply
               let encryptedBack = DESEncryptor.encryptBase64String(key, separateLines: true)
               print("Decrypted Text = \(encryptedBack!)")
               print("Decrypted Text = \(encryptedBack!.utf8)")
        self.result.text = ""
        self.result.text = encryptedBack
    }
}

