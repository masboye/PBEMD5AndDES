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
        
        let encryptedData = DESEncryptor.encryptData(plainData)
        print(encryptedData!.base64EncodedString())
        //print("\(encryptedData)")
        
        let str = String(decoding: encryptedData!, as: UTF8.self)
        //print("\(str)")
        
        let decryptedData = DESEncryptor.decryptData(encryptedData)
        //print("\(decryptedData)")
        let strOrigional = String(decoding: decryptedData!, as: UTF8.self)
        print("\(strOrigional)")
    }


}

