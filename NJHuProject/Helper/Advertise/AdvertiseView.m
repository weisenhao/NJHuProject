//
//  AdvertiseView.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "AdvertiseView.h"
#import <YYImage/YYImage.h>

NSString *const NotificationContants_Advertise_Key = @"NotificationContants_Advertise_Key";

// 广告显示的时间
static NSTimeInterval const showTime = 5.0;

@interface AdvertiseView ()

@property (nonatomic, strong) YYAnimatedImageView *adView;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation AdvertiseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.adView];
        [self addSubview:self.countBtn];
    }
    return self;
}

- (void)show {
    // 倒计时方法2：定时器
    [self startTimer];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Target Action
- (void)pushToAd {
    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationContants_Advertise_Key object:nil];
}

- (void)countDown {
    self.count--;
    [self.countBtn setTitle:[NSString stringWithFormat:@"跳过%ld", self.count] forState:UIControlStateNormal];
    if (self.count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        [self dismiss];
    }
}

// 定时器倒计时
- (void)startTimer {
    self.count = showTime;
    if (self.countTimer == nil) {
        self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
}

#pragma mark - Property
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    self.adView.image = [YYImage imageWithContentsOfFile:filePath];
}

- (YYAnimatedImageView *)adView {
    if (_adView == nil) {
        _adView = [[YYAnimatedImageView alloc] initWithFrame:self.bounds];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
    }
    return _adView;
}

- (UIButton *)countBtn {
    if (_countBtn == nil) {
        CGFloat btnW = 60.f;
        CGFloat btnH = 30.f;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - btnW - 24.f, btnH, btnW, btnH)];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", (int)showTime] forState:UIControlStateNormal];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
    }
    return _countBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
