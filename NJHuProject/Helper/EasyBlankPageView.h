//
//  EasyBlankPageView.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EasyBlankType) {
    EasyBlankTypeNoData
};

@interface EasyBlankPageView : UIView

- (void)configWithType:(EasyBlankType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(UIButton *sender))block;

@end

@interface UIView (ConfigBlank)

@property (nonatomic, strong) EasyBlankPageView *blankPageView;

- (void)configBlankPage:(EasyBlankType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(UIButton *sender))block;

@end
