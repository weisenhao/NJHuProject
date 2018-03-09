//
//  IntroductoryPagesHelper.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroductoryPagesHelper : NSObject

+ (instancetype)shareInstance;

- (void)showIntroductoryPageView:(NSArray<NSString *> *)imageArray;

@end
