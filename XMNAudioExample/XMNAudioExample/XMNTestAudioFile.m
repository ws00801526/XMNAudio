//
//  XMNTestAudioFile.m
//  XMNAudioExample
//
//  Created by XMFraker on 16/6/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNTestAudioFile.h"

@implementation XMNTestAudioFile



@end




@implementation XMNTestAudioFile (XMNTestFiles)

+ (void)load {
    
    dispatch_async(dispatch_queue_create("fetch_test_audio_files", 0), ^{
       
        [[self class] localAudioFiles];
    });
}

static NSArray *localAudioFiles = nil;
static dispatch_once_t localAudioFileToken;
+ (NSArray *)localAudioFiles {
    
    
    dispatch_once(&localAudioFileToken, ^{
        NSArray *sons = @[@"MP3Sample",@"letitgo_j",@"letitgo_v",@"test"];
        NSMutableArray *songs = [NSMutableArray array];
        for (int i = 0 ; i < sons.count; i++) {
            XMNTestAudioFile *file = [[XMNTestAudioFile alloc] init];
            file.audioFileURL = [[NSBundle mainBundle] URLForResource:sons[i] withExtension:@"mp3"];
            [songs addObject:file];
        }
        localAudioFiles = [songs copy];
    });
    return localAudioFiles;
}

@end