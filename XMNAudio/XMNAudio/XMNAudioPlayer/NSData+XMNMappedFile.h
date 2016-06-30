//
//  NSData+XMNMappedFile.h
//  XMNAudioRecorderExample
//
//  Created by XMFraker on 16/6/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (XMNMappedFile)

+ (instancetype)xmn_dataWithMappedContentsOfFile:(NSString *)path;
+ (instancetype)xmn_dataWithMappedContentsOfURL:(NSURL *)url;

+ (instancetype)xmn_modifiableDataWithMappedContentsOfFile:(NSString *)path;
+ (instancetype)xmn_modifiableDataWithMappedContentsOfURL:(NSURL *)url;

- (void)xmn_synchronizeMappedFile;

@end
