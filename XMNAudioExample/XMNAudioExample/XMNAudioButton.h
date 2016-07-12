//
//  XMNAudioButton.h
//  XMNAudioExample
//
//  Created by XMFraker on 16/7/12.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMNAudio/XMNAudio.h>

@interface XMNAudioButton : UIControl

- (void)playWithAudioFile:(id<XMNAudioFile>)audioFile;
- (void)stop;

@end
