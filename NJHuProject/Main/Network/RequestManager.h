//
//  RequestManager.h
//  NJHuProject
//
//  Created by chrisbin on 12/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface RequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
