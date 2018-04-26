//
//  DownloadInfo.h
//  NJHuProject
//
//  Created by chrisbin on 13/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 下载进度发生改变的通知 */
UIKIT_EXTERN NSString * const DownloadProgressDidChangeNotification;
/** 下载状态发生改变的通知 */
UIKIT_EXTERN NSString * const DownloadStateDidChangeNotification;
/** 利用这个key从通知中取出对应的MJDownloadInfo对象 */
UIKIT_EXTERN NSString * const DownloadInfoKey;

/** 下载状态 */
typedef NS_ENUM(NSInteger, DownloadState) {
    DownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
    DownloadStateWillResume,   // 即将下载（等待下载）
    DownloadStateResumed,      // 下载中
    DownloadStateSuspened,     // 暂停中
    DownloadStateCompleted     // 已经完全下载完毕
};

/**
 *  跟踪下载进度的Block回调
 *
 *  @param bytesWritten              【这次回调】写入的数据量
 *  @param totalBytesWritten         【目前总共】写入的数据量
 *  @param totalBytesExpectedToWrite 【最终需要】写入的数据量
 */
typedef void (^DownloadProgressChangeBlock)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);

/**
 *  状态改变的Block回调
 *
 *  @param file     文件的下载路径
 *  @param error    失败的描述信息
 */
typedef void (^DownloadStateChangeBlock)(DownloadState state, NSString *file, NSError *error);

/** 根文件夹 */
static NSString * const DownloadRootDir = @"download";

@interface DownloadInfo : NSObject

/** 下载状态 */
@property (nonatomic, assign) DownloadState state;
/** 这次写入的数量 */
@property (nonatomic, assign) NSInteger bytesWritten;
/** 已下载的数量 */
@property (nonatomic, assign) NSInteger totalBytesWritten;
/** 文件的总大小 */
@property (nonatomic, assign) NSInteger totalBytesExpectedToWrite;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;
/** 文件路径 */
@property (nonatomic, copy) NSString *file;
/** 文件url */
@property (nonatomic, copy) NSString *url;
/** 下载的错误信息 */
@property (nonatomic, strong) NSError *error;
/** 下载速度 */
@property (nonatomic, strong) NSNumber *speed;

/** 存放所有的进度回调 */
@property (nonatomic, copy) DownloadProgressChangeBlock progressChangeBlock;
/** 存放所有的完毕回调 */
@property (nonatomic, copy) DownloadStateChangeBlock stateChangeBlock;

- (instancetype)initWithUrl:(NSString *)url;

/**
 *  恢复
 */
- (void)resume;

/**
 * 等待下载
 */
- (void)willResume;

/**
 *  暂停
 */
- (void)suspend;

#pragma mark - 代理方法处理
- (void)didReceiveResponse:(NSHTTPURLResponse *)response;

- (void)didReceiveData:(NSData *)data;

- (void)didCompleteWithError:(NSError *)error;

@end
