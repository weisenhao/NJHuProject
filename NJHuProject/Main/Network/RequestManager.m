//
//  RequestManager.m
//  NJHuProject
//
//  Created by chrisbin on 12/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+ (instancetype)sharedManager {
    static RequestManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 设置可接收的数据类型
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"application/xml", @"text/xml", @"*/*", nil];
        // 记录网络状态
        [self.reachabilityManager startMonitoring];
        // TODO 自定义处理数据
    }
    return self;
}

@end
