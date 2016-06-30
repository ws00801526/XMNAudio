//
//  XMNTestAudioFile.h
//  XMNAudioExample
//
//  Created by XMFraker on 16/6/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMNAudio/XMNAudioFile.h>

@interface XMNTestAudioFile : NSObject <XMNAudioFile>

@property (nonatomic, copy)   NSURL *audioFileURL;

@end


@interface XMNTestAudioFile (XMNTestFiles)

+ (NSArray *)localAudioFiles;

@end
