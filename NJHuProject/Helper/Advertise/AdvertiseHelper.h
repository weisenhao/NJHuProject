//
//  AdvertiseHelper.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseHelper : NSObject

+ (instancetype)sharedInstance;

- (void)showAdvertiserView:(NSArray<NSString *> *)imageArray;

@end
