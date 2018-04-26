//
//  DownloadManager.h
//  NJHuProject
//
//  Created by chrisbin on 13/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadInfo.h"

@interface DownloadManager : NSObject

/** 最大同时下载数 */
@property (assign, nonatomic) int maxDownloadingCount;

+ (instancetype)defaultManager;

/**
 *  暂停下载某个文件
 */
- (void)suspend:(NSString *)url;

/**
 *  获得某个文件的下载信息
 *
 *  @param url 文件的URL
 */
- (DownloadInfo *)downloadInfoForURL:(NSString *)url;

/**
 *  下载一个文件
 *
 *  @param url          文件的URL路径
 *  @param progress     下载进度的回调
 *  @param state        状态改变的回调
 *
 *  @return YES代表文件已经下载完毕
 */
- (DownloadInfo *)download:(NSString *)url progress:(DownloadProgressChangeBlock)progress state:(DownloadStateChangeBlock)state;

/**
 *  下载一个文件
 *
 *  @param url              文件的URL路径
 *  @param destinationPath  文件的存放路径
 *  @param progress         下载进度的回调
 *  @param state            状态改变的回调
 *
 *  @return YES代表文件已经下载完毕
 */
- (DownloadInfo *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(DownloadProgressChangeBlock)progress state:(DownloadStateChangeBlock)state;

@end
