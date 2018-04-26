//
//  DownloadManager.m
//  NJHuProject
//
//  Created by chrisbin on 13/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "DownloadManager.h"
#import <YYCategories/YYCategories.h>

/** 默认manager的标识 */
static NSString * const DowndloadManagerDefaultIdentifier = @"downloadmanager";

@interface DownloadManager ()<NSURLSessionDelegate>

/** session */
@property (strong, nonatomic) NSURLSession *session;
/** 存放所有文件的下载信息 */
@property (strong, nonatomic) NSMutableArray *downloadInfoArray;
/** 是否正在批量处理 */
@property (nonatomic, assign, getter=isBatching) BOOL batching;

@end

@implementation DownloadManager

/** 存放所有的manager */
static NSMutableDictionary *_manager;
/** 锁 */
static NSLock *_lock;

+ (void)initialize {
    _manager = [NSMutableDictionary dictionary];
    _lock = [[NSLock alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.maxDownloadingCount = 3;
        self.downloadInfoArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)manager {
    return [[self alloc] init];
}

+ (instancetype)managerWithIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return [self manager];
    }
    DownloadManager *manager = _manager[identifier];
    if (manager == nil) {
        manager = [self manager];
        _manager[identifier] = manager;
    }
    return manager;
}

+ (instancetype)defaultManager {
    return [self managerWithIdentifier:DowndloadManagerDefaultIdentifier];
}

#pragma mark - 懒加载
- (NSURLSession *)session {
    if (_session == nil) {
        // 配置
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        cfg.timeoutIntervalForRequest = 10.f;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        _session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:queue];
    }
    return _session;
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 获得下载信息
    DownloadInfo *info = [self downloadInfoForURL:dataTask.taskDescription];
    // 处理响应
    [info didReceiveResponse:(NSHTTPURLResponse *)response];
    // 继续
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 获得下载信息
    DownloadInfo *info = [self downloadInfoForURL:dataTask.taskDescription];
}

#pragma mark - 获得下载信息
- (DownloadInfo *)downloadInfoForURL:(NSString *)url {
    if (url == nil) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url==%@", url];
    DownloadInfo *info = [[self.downloadInfoArray filteredArrayUsingPredicate:predicate] firstObject];
    if (info == nil) {
        info = [[DownloadInfo alloc] initWithUrl:url];
        [self.downloadInfoArray addObject:info];
    }
    return info;
}

#pragma mark - 公共方法
- (DownloadInfo *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(DownloadProgressChangeBlock)progress state:(DownloadStateChangeBlock)state {
    if (url == nil) {
        return nil;
    }
    // 下载信息
    DownloadInfo *info = [self downloadInfoForURL:url];
    
    // 设置block
    info.progressChangeBlock = progress;
    info.stateChangeBlock = state;
    
    if (destinationPath) {
        info.file = destinationPath;
        info.filename = [destinationPath lastPathComponent];
    }
    
    return info;
}

- (DownloadInfo *)download:(NSString *)url progress:(DownloadProgressChangeBlock)progress state:(DownloadStateChangeBlock)state {
    return [self download:url toDestinationPath:nil progress:progress state:state];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    // 获得下载信息
    DownloadInfo *info = [self downloadInfoForURL:task.taskDescription];
    // 处理结束
    [info didCompleteWithError:error];
    // 恢复等待下载的
    [self resumeFirstWillResume];
}

#pragma mark - 文件操作
/**
 * 让第一个等待下载的文件开始下载
 */
- (void)resumeFirstWillResume {
    if (self.isBatching) {
        return ;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state==%d", DownloadStateWillResume];
    DownloadInfo *willInfo = [[self.downloadInfoArray filteredArrayUsingPredicate:predicate] firstObject];
    [self resume:willInfo.url];
}

- (void)suspend:(NSString *)url {
    if (url == nil) {
        return ;
    }
    // 暂停
    [[self downloadInfoForURL:url] suspend];
    // 取出第一个等待下载的
    [self resumeFirstWillResume];
}

- (void)resume:(NSString *)url {
    if (url == nil) {
        return ;
    }
    // 获得下载信息
    DownloadInfo *info = [self downloadInfoForURL:url];
    // 正在下载的
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state==%d", DownloadStateResumed];
    NSArray *downloadingDownloadInfoArray = [self.downloadInfoArray filteredArrayUsingPredicate:predicate];
    if (self.maxDownloadingCount && downloadingDownloadInfoArray.count == self.maxDownloadingCount) {
        // 等待下载
        [info willResume];
    } else {
        // 继续
        [info resume];
    }
}

@end
