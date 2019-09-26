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
        let key = "SecretKey"
        let keyData = key.data(using: String.Encoding.ascii)
        
        let iv = [0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef]
        let ivData =  NSKeyedArchiver.archivedData(withRootObject: iv)
        
        
        let encryptedData = DESEncryptor.encryptData(plainData, key: keyData, iv: ivData)
        print("\(encryptedData)")
        
        let str = String(decoding: encryptedData!, as: UTF8.self)
        print("\(str)")
        
        let decryptedData = DESEncryptor.decryptData(encryptedData, key: keyData, iv: ivData)
        print("\(decryptedData)")
        let strOrigional = String(decoding: decryptedData!, as: UTF8.self)
        print("\(strOrigional)")
    }


}

