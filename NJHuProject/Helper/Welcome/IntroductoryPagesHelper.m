//
//  IntroductoryPagesHelper.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "IntroductoryPagesHelper.h"
#import "IntroductoryPagesView.h"
#import <YYCategories/YYCGUtilities.h>

@interface IntroductoryPagesHelper ()

@property (nonatomic, strong) IntroductoryPagesView *curIntroductoryPagesView;

@end

@implementation IntroductoryPagesHelper

+ (instancetype)shareInstance {
    static IntroductoryPagesHelper *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[IntroductoryPagesHelper alloc] init];
    });
    return _shareInstance;
}

- (void)showIntroductoryPageView:(NSArray<NSString *> *)imageArray {
    if (self.curIntroductoryPagesView == nil) {
        self.curIntroductoryPagesView = [IntroductoryPagesView pagesViewWithFrame:[UIScreen mainScreen].bounds images:imageArray];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.curIntroductoryPagesView];
}

@end
