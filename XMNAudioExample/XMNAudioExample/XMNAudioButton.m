//
//  XMNAudioButton.m
//  XMNAudioExample
//
//  Created by XMFraker on 16/7/12.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNAudioButton.h"

@interface XMNAudioButton ()

@property (nonatomic, weak) id<XMNAudioFile> audioFile;
@property (nonatomic, strong) XMNAudioPlayer *player;
@property (nonatomic, assign) XMNAudioPlayerStatus audioStatus;

@property (nonatomic, strong)   UIImageView *statusImageView;
@property (nonatomic, strong)   UIActivityIndicatorView *indicatorView;

@end

@implementation XMNAudioButton


#pragma mark - Life Cycle

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self addSubview:self.statusImageView];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.indicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.statusImageView sizeToFit];
    self.statusImageView.frame = CGRectMake(10, self.bounds.size.height/2 - self.statusImageView.frame.size.height/2, self.statusImageView.frame.size.width, self.statusImageView.frame.size.height);
}

#pragma mark - Override Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.audioStatus = self.player.status;
        });
    }
}

#pragma mark - Methods

- (void)playWithAudioFile:(id<XMNAudioFile>)audioFile {
    
    if (self.player) {
        self.audioStatus = XMNAudioPlayerStatusFinished;
    }else {
        self.player = [XMNAudioPlayer playerWithAudioFile:audioFile];
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.player play];
    }
}

- (void)stop {
    
    self.audioStatus = XMNAudioPlayerStatusFinished;
}

#pragma mark - Setters

- (void)setAudioStatus:(XMNAudioPlayerStatus)audioStatus {
    
    if (_audioStatus != audioStatus) {
        _audioStatus = audioStatus;
        self.statusImageView.hidden = NO;
        self.indicatorView.hidden = NO;
        [self.indicatorView stopAnimating];
        
        switch (audioStatus) {
            case XMNAudioPlayerStatusBuffering:
            {
                [self.indicatorView startAnimating];
                self.statusImageView.hidden = YES;
            }
                break;
            case XMNAudioPlayerStatusPlaying:
            {
                self.statusImageView.highlighted = YES;
                [self.statusImageView startAnimating];
                [self.indicatorView stopAnimating];
                self.indicatorView.hidden = YES;
            }
                break;
            default:
            {
                [self.statusImageView stopAnimating];
                self.statusImageView.highlighted = NO;
                [self.indicatorView stopAnimating];
                self.indicatorView.hidden = YES;
                
                if (self.player) {
                    [self.player stop];
                    [self.player removeObserver:self forKeyPath:@"status"];
                    self.player = nil;
                }
            }
                break;
        }
    }
}

#pragma mark - Getters

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.image = [UIImage imageNamed:@"message_voice_receiver_normal"];
        UIImage *image1 = [UIImage imageNamed:@"message_voice_receiver_playing_1"];
        UIImage *image2 = [UIImage imageNamed:@"message_voice_receiver_playing_2"];
        UIImage *image3 = [UIImage imageNamed:@"message_voice_receiver_playing_3"];
        _statusImageView.highlightedAnimationImages = @[image1,image2,image3];
        _statusImageView.animationDuration = 1.5f;
        _statusImageView.animationRepeatCount = NSUIntegerMax;
    }
    return _statusImageView;
}


- (UIActivityIndicatorView *)indicatorView {
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
