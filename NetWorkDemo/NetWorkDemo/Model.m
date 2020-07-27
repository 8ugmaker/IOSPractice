//
//  Model.m
//  NetWorkDemo
//
//  Created by huyanxin on 2020/7/27.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (id)dataInject:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.iconURL = dic[@"picture"];
        self.content = dic[@"message"];
        self.time = dic[@"time"];
        self.unreadCount = dic[@"unreadCount"];
    }
    return self;
}

@end
