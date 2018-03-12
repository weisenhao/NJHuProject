//
//  ListExpendHeaderView.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "ListExpendHeader.h"
#import "Group.h"
#import <Masonry/Masonry.h>

@interface ListExpendHeader ()

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton *indicatorButton;

@end

@implementation ListExpendHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerLabel];
        [self.contentView addSubview:self.indicatorButton];
        [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10.f);
            make.top.bottom.offset(0);
        }];
        [self.indicatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.offset(0);
            make.width.offset(100.f);
        }];
    }
    return self;
}

- (void)setGroup:(Group *)group {
    _group = group;
    self.textLabel.text = _group.name;
    self.indicatorButton.imageView.transform = _group.isOpened ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
}

#pragma mark - Target Action
- (void)indicatorAction:(UIButton *)button {
    if (self.selectGroup) {
        self.selectGroup();
    }
    if (self.group.isOpened) {
        [UIView animateWithDuration:0.3f animations:^{
            self.indicatorButton.imageView.transform = CGAffineTransformIdentity;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.indicatorButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

- (UILabel *)headerLabel {
    if (_headerLabel == nil) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.textColor = [UIColor blackColor];
    }
    return _headerLabel;
}

- (UIButton *)indicatorButton {
    if (_indicatorButton == nil) {
        _indicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indicatorButton setImage:[UIImage imageNamed:@"arrow_down_icon"] forState:UIControlStateNormal];
        [_indicatorButton addTarget:self action:@selector(indicatorAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _indicatorButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
