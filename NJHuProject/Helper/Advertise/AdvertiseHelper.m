//
//  AdvertiseHelper.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "AdvertiseHelper.h"
#import "AdvertiseView.h"

@implementation AdvertiseHelper

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static AdvertiseHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)showAdvertiserView:(NSArray<NSString *> *)imageArray {
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:ADImageName];
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        AdvertiseView *view = [[AdvertiseView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        view.filePath = filePath;
        [view show];
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage:imageArray];
}

#pragma mark - Private Method
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths firstObject] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage:(NSArray *)imageArray {
    // 随机取一张
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    NSString *imageName = [imageUrl componentsSeparatedByString:@"/"].lastObject;
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist) { // 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
    }
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        if ([data writeToFile:filePath atomically:YES]) {
            NSLog(@"保存成功");
            [self deleteOldImage];
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:ADImageName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 如果有广告链接，将广告链接也保存下来
        } else {
            NSLog(@"保存失败");
        }
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage {
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:ADImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
