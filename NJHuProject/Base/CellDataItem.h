//
//  WordItem.h
//  NJHuProject
//
//  Created by chrisbin on 08/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellDataItem : NSObject

// 标题
@property (nonatomic, copy) NSString *title;
// 副标题
@property (nonatomic, copy) NSString *subTitle;
// AccessoryType
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
// 跳转页
@property (nonatomic, assign) Class destVC;
// 点击操作
@property (nonatomic, copy) void(^itemOperation)(NSIndexPath *indexPath);

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(UITableViewCellAccessoryType)type;

@end
