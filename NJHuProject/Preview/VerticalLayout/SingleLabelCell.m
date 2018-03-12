//
//  SingleLabelCell.m
//  NJHuProject
//
//  Created by chrisbin on 12/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "SingleLabelCell.h"

@implementation SingleLabelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label.frame = CGRectMake(0, 0, 0, 0);
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor redColor];
        _label.font = [UIFont boldSystemFontOfSize:17.f];
    }
    return _label;
}

@end
