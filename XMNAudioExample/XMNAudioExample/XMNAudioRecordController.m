//
//  XMNAudioRecordController.m
//  XMNAudioExample
//
//  Created by XMFraker on 16/6/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNAudioRecordController.h"

#import <XMNAudio/XMNAudio.h>

@interface XMNAudioRecordController ()

@property (nonatomic, strong) XMNAudioRecorder *recorder;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@end

@implementation XMNAudioRecordController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.recorder = [[XMNAudioRecorder alloc] init];
}

- (IBAction)handleRecord:(UIButton *)sender {
    
    if (self.recorder.isRecording) {
        [self.recorder stopRecording];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        NSLog(@"Record Finished :%@",[[self.recorder filePath] stringByAppendingPathComponent:[self.recorder filename]]);
        self.segmentedControl.enabled = YES;
        return;
    }
    [self.recorder setConvertType:self.segmentedControl.selectedSegmentIndex];
    [self.recorder startRecording];
    [sender setTitle:@"Stop Record" forState:UIControlStateNormal];
    self.segmentedControl.enabled = NO;
}


- (IBAction)handlePlay:(UIButton *)sender {

    NSLog(@"todo  play");
}

@end
