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
        
        //let decryptedText = DESEncryptor.decryptBase64String(encryptedText!, keyString: DESEncryptor.keyString)
        let encryptedReply = "MkcoDTpa78C2/lcLe+gZUHYL7zhrK38ZWyNMpAssRvs="
        let key = "aa7ba8147699o4Ox4eke/mglen302opQ=="
        DESEncryptor.keyString = key
        let decryptedReply = DESEncryptor.decryptBase64String(encryptedReply)
        print("Decrypted Text = \(decryptedReply!)")
        
        
    }


}

