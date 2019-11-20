//
//  STEncryptorDES.m
//
//
//  Created by Nimit S. Parekh on 27/01/14.
//
//

#import "DESEncryptor.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation DESEncryptor
#pragma mark -
#pragma mark Initialization and deallcation


#pragma mark -
#pragma mark Praivate


#pragma mark -
#pragma mark API

//static NSString *keyString = @"SecretKey";
static NSString * _keyString = @"DefaultKey";
+ (NSString *)keyString { return _keyString; }
+ (void)setKeyString:(NSString *)newString { _keyString = newString; }

unsigned char salt[] =  {0xA9,0x9B,0xC8,0x32,0x56,0x35,0xE3,0x03};

+ (NSData*)encryptData:(NSData*)data ;
{
    NSData* result = nil;
    NSData *key = [_keyString dataUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    memset(md5Buffer, 0, CC_MD5_DIGEST_LENGTH);
    CC_MD5_CTX md5Ctx;
    CC_MD5_Init(&md5Ctx);
    CC_MD5_Update(&md5Ctx, [key bytes], [key length]);
    
    CC_MD5_Update(&md5Ctx, salt, 8);
    CC_MD5_Final(md5Buffer, &md5Ctx);
    
    for (int i=1; i<19; i++) {
        CC_MD5(md5Buffer, CC_MD5_DIGEST_LENGTH, md5Buffer);
    }
    
    // DES-CBC requires an explicit Initialization Vector (IV)
    // IV - second half of md5 key
    unsigned char IV[kCCBlockSizeDES];
    memcpy(IV, md5Buffer + CC_MD5_DIGEST_LENGTH / 2, sizeof(IV));
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          md5Buffer,
                                          CC_MD5_DIGEST_LENGTH/2,
                                          IV,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    
    return result;
}

+ (NSData*)decryptData:(NSData*)data ;
{
    NSData* result = nil;
    NSData *key = [_keyString dataUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    memset(md5Buffer, 0, CC_MD5_DIGEST_LENGTH);
    CC_MD5_CTX md5Ctx;
    CC_MD5_Init(&md5Ctx);
    CC_MD5_Update(&md5Ctx, [key bytes], [key length]);
    
    CC_MD5_Update(&md5Ctx, salt, 8);
    CC_MD5_Final(md5Buffer, &md5Ctx);
    
    for (int i=1; i<19; i++) {
        CC_MD5(md5Buffer, CC_MD5_DIGEST_LENGTH, md5Buffer);
    }
    
    // DES-CBC requires an explicit Initialization Vector (IV)
    // IV - second half of md5 key
    unsigned char IV[kCCBlockSizeDES];
    memcpy(IV, md5Buffer + CC_MD5_DIGEST_LENGTH / 2, sizeof(IV));
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          md5Buffer,
                                          CC_MD5_DIGEST_LENGTH/2,
                                          IV,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }
    
    return result;
}


+ (NSString*)encryptBase64String:(NSString*)string separateLines:(BOOL)separateLines
{
    NSData* data = [self encryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return [data base64EncodedStringWithSeparateLines:separateLines];
}

+ (NSString*)decryptBase64String:(NSString*)encryptedBase64String
{
    NSData* encryptedData = [NSData dataFromBase64String:encryptedBase64String];
    NSData* data = [self decryptData:encryptedData ];
    if (data) {
        return [[NSString alloc] initWithData:data
                                      encoding:NSUTF8StringEncoding] ;
    } else {
        return nil;
    }
}


#define FBENCRYPT_IV_HEX_LEGNTH (FBENCRYPT_BLOCK_SIZE*2)

+ (NSData*)generateIv
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand(time(NULL));
    });
    
    char cIv[FBENCRYPT_BLOCK_SIZE];
    for (int i=0; i < FBENCRYPT_BLOCK_SIZE; i++) {
        cIv[i] = rand() % 256;
    }
    return [NSData dataWithBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
}


+ (NSString*)hexStringForData:(NSData*)data
{
    if (data == nil) {
        return nil;
    }
    
    NSMutableString* hexString = [NSMutableString string];
    
    const unsigned char *p = [data bytes];
    
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return hexString;
}

+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        } else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

@end
