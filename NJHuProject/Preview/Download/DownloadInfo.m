//
//  DownloadInfo.m
//  NJHuProject
//
//  Created by chrisbin on 13/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "DownloadInfo.h"
#import <YYCategories/YYCategories.h>

NSString * const DownloadProgressDidChangeNotification = @"DownloadProgressDidChangeNotification";
NSString * const DownloadStateDidChangeNotification = @"DownloadStateDidChangeNotification";
NSString * const DownloadInfoKey = @"DownloadInfoKey";

@interface DownloadInfo ()

/** 任务 */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/** 文件流 */
@property (nonatomic, strong) NSOutputStream *stream;

@end

@implementation DownloadInfo

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = [url copy];
    }
    return self;
}

- (NSString *)filename {
    if (_filename == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _filename = [NSString stringWithFormat:@"%@.%@", self.url.md5String, pathExtension];
        } else {
            _filename = self.url.md5String;
        }
    }
    return _filename;
}

- (NSString *)file {
    if (_file == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", DownloadRootDir, self.filename];
        _file = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:path];
    }
    if (_file && ![[NSFileManager defaultManager] fileExistsAtPath:_file]) {
        NSString *dir = [_file stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _file;
}

- (NSOutputStream *)stream {
    if (_stream == nil) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.file append:YES];
    }
    return _stream;
}

- (NSInteger)totalBytesWritten {
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:self.file error:nil];
    return [[dict objectForKey:NSFileSize] integerValue];
}

/**
 *  恢复
 */
- (void)resume {
    if (self.state == DownloadStateCompleted || self.state == DownloadStateResumed) {
        return ;
    }
    [self.task resume];
    self.state = DownloadStateResumed;
}

/**
 * 等待下载
 */
- (void)willResume {
    if (self.state == DownloadStateCompleted || self.state == DownloadStateResumed) {
        return ;
    }
    self.state = DownloadStateWillResume;
}

/**
 *  暂停
 */
- (void)suspend {
    if (self.state == DownloadStateCompleted || self.state == DownloadStateSuspened) {
        
    } else if (self.state == DownloadStateResumed) {    // 如果是正在下载
        [self.task suspend];
        self.state = DownloadStateSuspened;
    } else {    // 如果是等待下载
        self.state = DownloadStateNone;
    }
}

#pragma mark - 状态控制
- (void)setState:(DownloadState)state {
    if (_state != state) {
        _state = state;
        // 发通知
        [self notifyStateChange];
    }
}

/**
 *  通知进度改变
 */
- (void)notifyProgressChange {
    if (self.progressChangeBlock) {
        self.progressChangeBlock(self.bytesWritten, self.totalBytesWritten, self.totalBytesExpectedToWrite);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadStateDidChangeNotification object:self userInfo:@{DownloadInfoKey: self}];
}

/**
 *  通知下载状态改变
 */
- (void)notifyStateChange {
    if (self.stateChangeBlock) {
        self.stateChangeBlock(self.state, self.file, self.error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadStateDidChangeNotification object:self userInfo:@{DownloadInfoKey: self}];
}

#pragma mark - 代理方法处理
- (void)didReceiveResponse:(NSHTTPURLResponse *)response {
    if (self.totalBytesExpectedToWrite == 0) {
        self.totalBytesExpectedToWrite = [response.allHeaderFields[@"Content-Length"] integerValue] + self.totalBytesWritten;
    }
    // 打开流
    [self.stream open];
    // 清空错误
    self.error = nil;
}

- (void)didReceiveData:(NSData *)data {
    // 写数据
    NSInteger result = [self.stream write:data.bytes maxLength:data.length];
    if (result == -1) {
        self.error = self.stream.streamError;
        [self.task cancel]; // 取消请求
    } else {
        self.bytesWritten = data.length;
        [self notifyProgressChange];    // 通知进度改变
    }
}

- (void)didCompleteWithError:(NSError *)error {
    // 关闭流
    [self.stream close];
    self.bytesWritten = 0;
    self.stream = nil;
    self.task = nil;
    
    // 错误(避免nil的error覆盖掉之前设置的self.error)
    self.error = error ? error : self.error;
    
    // 通知(如果下载完毕 或者 下载出错了)
    if (self.state == DownloadStateCompleted || error) {
        self.state = error ? DownloadStateNone : DownloadStateCompleted;
    }
}

@end
