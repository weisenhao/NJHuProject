//
//  AdvertiseView.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const NotificationContants_Advertise_Key;

static NSString *const ADImageName = @"ADImageName";

@interface AdvertiseView : UIView

@property (nonatomic, copy) NSString *filePath;

// 显示广告页面方法
- (void)show;

@end
