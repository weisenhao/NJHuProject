//
//  Group.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "Group.h"
#import <MJExtension/MJExtension.h>

@implementation Team

@end

@implementation Group

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"teams": [Team class]};
}

- (NSMutableArray<Team *> *)teams {
    if (_teams == nil) {
        _teams = [NSMutableArray array];
    }
    return _teams;
}

@end
