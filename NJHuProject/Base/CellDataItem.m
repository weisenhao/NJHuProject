//
//  WordItem.m
//  NJHuProject
//
//  Created by chrisbin on 08/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "CellDataItem.h"

@implementation CellDataItem

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(UITableViewCellAccessoryType)type {
    if (self = [super init]) {
        _title = title;
        _subTitle = subTitle;
        _accessoryType = type;
    }
    return self;
}

@end
