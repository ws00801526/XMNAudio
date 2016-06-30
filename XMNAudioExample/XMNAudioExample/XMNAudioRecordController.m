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


@end

@implementation XMNAudioRecordController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.recorder = [[XMNAudioRecorder alloc] init];
    [self.recorder setConvertType:XMNAudioEncoderTypeAMR];
}

- (IBAction)handleRecord:(UIButton *)sender {
    
    if (self.recorder.isRecording) {
        [self.recorder stopRecording];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        NSLog(@"Record Finished :%@",[[self.recorder filePath] stringByAppendingPathComponent:[self.recorder filename]]);
        return;
    }
    [self.recorder startRecording];
    [sender setTitle:@"Stop Record" forState:UIControlStateNormal];

}


- (IBAction)handlePlay:(UIButton *)sender {

    NSLog(@"todo  play");
}

@end
