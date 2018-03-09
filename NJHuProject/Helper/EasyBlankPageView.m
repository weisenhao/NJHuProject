//
//  EasyBlankPageView.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "EasyBlankPageView.h"
#import <YYImage/YYImage.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@interface EasyBlankPageView ()

@property (nonatomic, strong) UIButton *reloadBtn;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, copy) void(^reloadBlock)(UIButton *sender);

@end

@implementation EasyBlankPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tipLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.reloadBtn];
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.left.right.equalTo(self.imageView);
            make.top.offset(frame.size.height * 0.2);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(10.f);
            make.centerX.offset(0);
        }];
        [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(self.imageView.mas_bottom).offset(10.f);
            make.left.right.equalTo(self.imageView);
            make.height.offset(44.f);
        }];
    }
    return self;
}

- (void)configWithType:(EasyBlankType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(UIButton *sender))block {
    if (hasData) {
        [self removeFromSuperview];
        return ;
    }
    self.reloadBtn.hidden = YES;
    self.tipLabel.hidden = YES;
    self.imageView.hidden = YES;
    self.reloadBlock = block;
    if (hasError) {
        [self.imageView setImage:[UIImage imageNamed:@"common_noNetWork"]];
        self.tipLabel.text = @"貌似出了点差错";
        self.reloadBtn.hidden = NO;
        self.tipLabel.hidden = NO;
        self.imageView.hidden = NO;
    } else if(blankPageType == EasyBlankTypeNoData) {
        [self.imageView setImage:[UIImage imageNamed:@"common_noRecord"]];
        self.tipLabel.text = @"暂无数据";
        self.reloadBtn.hidden = NO;
        self.tipLabel.hidden = NO;
        self.imageView.hidden = NO;
    }
}

#pragma mark - Targer Action
- (void)reloadClick:(UIButton *)btn {
    if (self.reloadBlock) {
        self.reloadBlock(btn);
    }
}

#pragma mark - Property
- (UIButton *)reloadBtn {
    if (_reloadBtn == nil) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}

- (YYAnimatedImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.autoPlayAnimatedImage = YES;
    }
    return _imageView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tipLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

static char BlankPageViewKey;

@implementation UIView (ConfigBlank)

- (void)setBlankPageView:(EasyBlankPageView *)blankPageView {
    objc_setAssociatedObject(self, &BlankPageViewKey, blankPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EasyBlankPageView *)blankPageView {
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EasyBlankType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(UIButton *))block {
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    } else {
        if (!self.blankPageView) {
            CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.blankPageView = [[EasyBlankPageView alloc] initWithFrame:frame];
        }
        self.blankPageView.hidden = NO;
        [self addSubview:self.blankPageView];
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

@end

