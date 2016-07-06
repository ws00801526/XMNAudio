//
//  XMNTestAudioFile.m
//  XMNAudioExample
//
//  Created by XMFraker on 16/6/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNTestAudioFile.h"

@implementation XMNTestAudioFile

- (AudioFileTypeID)fileTypeID {
    
    if ([[[self audioFileURL] pathExtension] isEqualToString:@"mp3"]) {
        return kAudioFileMP3Type;
    }else if ([[[self audioFileURL] pathExtension] isEqualToString:@"amr"]) {
        return kAudioFileAMRType;
    }
    return 0;
}

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
        NSArray<NSString *> *fileNames = @[@"MP3Sample.mp3",
                                           @"letitgo_j.mp3",
                                           @"letitgo_v.mp3",
                                           @"AMR1.amr",
                                           @"AMR2.amr",
                                           @"MP3.mp3"];
        NSMutableArray *songs = [NSMutableArray array];
        
        [fileNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XMNTestAudioFile *file = [[XMNTestAudioFile alloc] init];
            file.audioFileURL = [[NSBundle mainBundle] URLForResource:[obj lastPathComponent] withExtension:nil];
            [songs addObject:file];
        }];
        
        XMNTestAudioFile *audioFile = [[XMNTestAudioFile alloc] init];
        audioFile.audioFileURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/ws00801526/XMNAudio/master/XMNAudioExample/XMNAudioExample/letitgo_v.mp3"];
        [songs addObject:audioFile];
        localAudioFiles = [songs copy];
    });
    return localAudioFiles;
}

@end