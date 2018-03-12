//
//  Group.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, copy) NSString *sortNumber;
@property (nonatomic, copy) NSString *name;

@end

@interface Group : NSObject

@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray<Team *> *teams;

@end
