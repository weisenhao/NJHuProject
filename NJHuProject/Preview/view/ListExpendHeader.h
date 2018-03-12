//
//  ListExpendHeaderView.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;
@interface ListExpendHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) Group *group;
@property (nonatomic, copy) BOOL(^selectGroup)(void);

@end
