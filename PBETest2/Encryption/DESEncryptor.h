//
//  STEncryptorDES.h
//
//
//  Created by Nimit S. Parekh on 27/01/14.
//
//

#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

#define FBENCRYPT_ALGORITHM     kCCAlgorithmDES
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeDES
#define FBENCRYPT_KEY_SIZE      kCCKeySizeDES

@interface DESEncryptor : NSObject {
   // @property (class, nonatomic, assign) NSString keyString;
    
}

//-----------------
// API (raw data)
//-----------------
+ (NSData*)generateIv;
+ (NSData*)encryptData:(NSData*)data;
+ (NSData*)decryptData:(NSData*)data;
@property (class) NSString *keyString;
//-----------------
// API (base64)
//-----------------
// the return value of encrypteMessage: and 'encryptedMessage' are encoded with base64.
//
+ (NSString*)encryptBase64String:(NSString*)string separateLines:(BOOL)separateLines;
+ (NSString*)decryptBase64String:(NSString*)encryptedBase64String ;

//-----------------
// API (utilities)
//-----------------
+ (NSString*)hexStringForData:(NSData*)data;
+ (NSData*)dataForHexString:(NSString*)hexString;


@end
