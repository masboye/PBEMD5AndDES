//
//  TokenGenerator.swift
//  SimkeuRestClient
//
//  Created by boy setiawan on 04/11/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation

struct TokenGenerator {
    
    func generate() -> String {
         let encryptedReply = "LJwUdcxbbZb6hhvT2NmCZvUvmA5uT3pwVjQvE4co0q0="
               let key = "c5f0d92cecZeWrcDMHY8S31p7RVyvdNA=="
               DESEncryptor.keyString = key
               let decryptedReply = DESEncryptor.decryptBase64String(encryptedReply)
               print("Decrypted Text = \(decryptedReply!)")
               DESEncryptor.keyString = decryptedReply
               let encryptedBack = DESEncryptor.encryptBase64String(key, separateLines: true)
               print("Decrypted Text = \(encryptedBack!)")
        
    }
}
