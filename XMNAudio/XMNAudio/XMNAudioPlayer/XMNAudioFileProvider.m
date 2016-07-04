//
//  XMNAudioFileProvider.m
//  XMNAudioRecorderExample
//
//  Created by XMFraker on 16/6/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNAudioFileProvider.h"

#include <CommonCrypto/CommonDigest.h>
#include <AudioToolbox/AudioToolbox.h>

#if TARGET_OS_IPHONE
#include <MobileCoreServices/MobileCoreServices.h>
#else /* TARGET_OS_IPHONE */
#include <CoreServices/CoreServices.h>
#endif /* TARGET_OS_IPHONE */

#import "NSData+XMNMappedFile.h"

static id <XMNAudioFile> gHintFile = nil;
static XMNAudioFileProvider *gHintProvider = nil;
static BOOL gLastProviderIsFinished = NO;

@interface XMNAudioFileProvider()
{
@protected
    id <XMNAudioFile> _audioFile;
    XMNAudioFileProviderEventBlock _eventBlock;
    NSString *_cachedPath;
    NSURL *_cachedURL;
    NSString *_mimeType;
    NSString *_fileExtension;
    NSString *_sha256;
    NSData *_mappedData;
    NSUInteger _expectedLength;
    NSUInteger _receivedLength;
    BOOL _failed;
}
@end


@interface XMNAudioLocalFileProvider : XMNAudioFileProvider

@end

@interface XMNAudioRemoteFileProvider : XMNAudioFileProvider
{
@private
    NSURLSessionDownloadTask *_downloadTask;
    NSURL *_audioFileURL;
    NSString *_audioFileHost;
    
    CC_SHA256_CTX *_sha256Ctx;
    
    AudioFileStreamID _audioFileStreamID;
    BOOL _requiresCompleteFile;
    BOOL _readyToProducePackets;
    BOOL _requestCompleted;
}
@end


#pragma mark - Abstract Class XMNAudioFileProvider

@implementation XMNAudioFileProvider
@synthesize audioFile = _audioFile;
@synthesize eventBlock = _eventBlock;
@synthesize cachedPath = _cachedPath;
@synthesize cachedURL = _cachedURL;
@synthesize mimeType = _mimeType;
@synthesize fileExtension = _fileExtension;
@synthesize sha256 = _sha256;
@synthesize mappedData = _mappedData;
@synthesize expectedLength = _expectedLength;
@synthesize receivedLength = _receivedLength;
@synthesize failed = _failed;

#pragma mark - XMNAudioFileProvider Life Cycle

+ (instancetype)fileProviderWithAudioFile:(id<XMNAudioFile>)audioFile {
    
    /** 如果全局已经生成了provider 则返回 不用再次创建 */
    if ((audioFile == gHintFile ||
         [audioFile isEqual:gHintFile]) &&
        gHintProvider != nil) {
        
        XMNAudioFileProvider *provider = gHintProvider;
        gHintFile = nil;
        gHintProvider = nil;
        gLastProviderIsFinished = [provider isFinished];
        return provider;
    }
    
    gHintFile = nil;
    gHintProvider = nil;
    gLastProviderIsFinished = NO;
    
    return [self _fileProviderWithAudioFile:audioFile];
}

+ (instancetype)_fileProviderWithAudioFile:(id <XMNAudioFile>)audioFile
{
    if (audioFile == nil) {
        return nil;
    }
    
    NSURL *audioFileURL = [audioFile audioFileURL];
    if (audioFileURL == nil) {
        return nil;
    }
    
    if ([audioFileURL isFileURL]) {
        /** 文件是一个本地文件 */
        return [[XMNAudioLocalFileProvider alloc] initWithAudioFile:audioFile];
    }
#if TARGET_OS_IPHONE
    else if ([[audioFileURL scheme] isEqualToString:@"ipod-library"]) {
        //        return [[_DOUAudioMediaLibraryFileProvider alloc] _initWithAudioFile:audioFile];
    }
#endif /* TARGET_OS_IPHONE */
    else {
        //        return [[_DOUAudioRemoteFileProvider alloc] _initWithAudioFile:audioFile];
    }
    return nil;
}

+ (void)setHintWithAudioFile:(id<XMNAudioFile>)audioFile {
    
    if (audioFile == gHintFile ||
        [audioFile isEqual:gHintFile]) {
        return;
    }
    
    if (audioFile == nil) {
        return;
    }
    
    NSURL *audioFileURL = [audioFile audioFileURL];
    if (audioFileURL == nil ||
#if TARGET_OS_IPHONE
        [[audioFileURL scheme] isEqualToString:@"ipod-library"] ||
#endif /* TARGET_OS_IPHONE */
        [audioFileURL isFileURL]) {
        return;
    }
    
    gHintFile = audioFile;
    
    if (gLastProviderIsFinished) {
        gHintProvider = [self _fileProviderWithAudioFile:gHintFile];
    }
}

- (instancetype)initWithAudioFile:(id <XMNAudioFile>)audioFile {
    
    if (self = [super init]) {
        
        _audioFile = audioFile;
    }
    return self;
}

#pragma mark - XMNAudioFileProvider Getters

- (NSUInteger)downloadSpeed {
    
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (BOOL)isReady {
    
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (BOOL)isFinished {
    
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

@end

#pragma mark - Implementation of XMNAudioLocalFileProvider 

@implementation XMNAudioLocalFileProvider


#pragma mark - XMNAudioLocalFileProvider Life Cycle
    
- (instancetype)initWithAudioFile:(id <XMNAudioFile>)audioFile {
    
    if (self = [super initWithAudioFile:audioFile]) {
        
        _cachedURL = [audioFile audioFileURL];
        _cachedPath = [_cachedURL path];
        
        BOOL isDirectory = NO;
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cachedPath
                                                  isDirectory:&isDirectory] ||
            isDirectory) {
            return nil;
        }
        
        _mappedData = [NSData xmn_dataWithMappedContentsOfFile:_cachedPath];
        _expectedLength = [_mappedData length];
        _receivedLength = [_mappedData length];
    }
    return self;
}


#pragma mark - XMNAudioLocalFileProvider Getters

- (NSString *)mimeType {
    
    if (_mimeType == nil &&
        [self fileExtension] != nil) {
        CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[self fileExtension], NULL);
        if (uti != NULL) {
            _mimeType = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType));
            CFRelease(uti);
        }
    }
    return _mimeType;
}

- (NSString *)fileExtension {
    
    if (_fileExtension == nil) {
        _fileExtension = [[[self audioFile] audioFileURL] pathExtension];
    }
    return _fileExtension;
}

- (NSString *)sha256 {
    
    if (_sha256 == nil &&
        [self mappedData] != nil) {
        unsigned char hash[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256([[self mappedData] bytes], (CC_LONG)[[self mappedData] length], hash);
        
        NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
        for (size_t i = 0; i < CC_SHA256_DIGEST_LENGTH; ++i) {
            [result appendFormat:@"%02x", hash[i]];
        }
        _sha256 = [result copy];
    }
    return _sha256;
}

- (NSUInteger)downloadSpeed {
    
    return _receivedLength;
}

- (BOOL)isReady {
    
    /** 本地文件 可以直接播放 */
    return YES;
}

- (BOOL)isFinished {
    
    /** 本地文件 可以直接播放 */
    return YES;
}

@end


#pragma mark - Implementation of XMNAudioRemoteFileProvider

@implementation XMNAudioRemoteFileProvider
@synthesize finished = _requestCompleted;

- (instancetype)initWithAudioFile:(id <XMNAudioFile>)audioFile {
    
    if (self = [super initWithAudioFile:audioFile]) {
        
        _audioFileURL = [audioFile audioFileURL];
        if ([audioFile respondsToSelector:@selector(audioFileHost)]) {
            _audioFileHost = [audioFile audioFileHost];
        }
        _sha256Ctx = (CC_SHA256_CTX *)malloc(sizeof(CC_SHA256_CTX));
        CC_SHA256_Init(_sha256Ctx);

    }
    return self;
}


#pragma mark - Audio File Stream Methods



@end
