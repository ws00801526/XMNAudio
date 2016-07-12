//
//  XMNAudioPlayerController.m
//  XMNAudioExample
//
//  Created by XMFraker on 16/6/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNAudioPlayerController.h"

#import <XMNAudio/XMNAudio.h>

#import "XMNTestAudioFile.h"
#import "XMNAudioButton.h"

@interface XMNAudioPlayerController ()

@property (nonatomic, strong) XMNAudioPlayer    *player;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy, readonly)   NSArray *songs;
@property (nonatomic, assign) BOOL remote;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) XMNAudioButton *audioButton;


@end

@implementation XMNAudioPlayerController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.audioButton = [[XMNAudioButton alloc] init];
    self.audioButton.frame = CGRectMake(50, 100, 100, 50);
    self.audioButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.audioButton];
    
    [self.audioButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playButtonAction:(XMNAudioButton *)audioButton {
    
    [audioButton playWithAudioFile:[[XMNTestAudioFile localAudioFiles] lastObject]];
}

- (IBAction)handlePlay:(UIButton *)sender {
    
    if (self.player) {
        if (self.player.status == XMNAudioPlayerStatusPaused || self.player.status == XMNAudioPlayerStatusFinished) {
            [self.player play];
            [sender setTitle:@"Pause" forState:UIControlStateNormal];
        }else {
            [self.player pause];
            [sender setTitle:@"Play" forState:UIControlStateNormal];
        }
    }else {
        self.player = [[XMNAudioPlayer alloc] initWithAudioFile:self.songs[self.index]];
        [self.player play];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
    }
}


- (IBAction)handleStop:(UIButton *)sender {
    
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

- (IBAction)handleLast:(UIButton *)sender {
 
    self.index --;
    self.index = self.index < 0 ? self.songs.count -1 : self.index;

    [self handleStop:nil];
    self.player = [[XMNAudioPlayer alloc] initWithAudioFile:self.songs[self.index]];
    [self.player play];
}


- (IBAction)handleNext:(UIButton *)sender {

    self.index ++;
    self.index = self.index >= self.songs.count ? 0 : self.index;
    
    [self handleStop:nil];

    self.player = [[XMNAudioPlayer alloc] initWithAudioFile:self.songs[self.index]];
    [self.player play];
}


- (IBAction)handleSliderValueChanged:(UISlider *)sender {
    
    [self.player setCurrentTime:sender.value * self.player.duration];
}
#pragma mark - Getters

- (NSArray *)songs {
    
    if (self.remote) {
        return nil;
    }
    return [XMNTestAudioFile localAudioFiles];
}

@end
