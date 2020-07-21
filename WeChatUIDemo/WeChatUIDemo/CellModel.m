//
//  CellModel.m
//  WeChatUIDemo
//
//  Created by huyanxin on 2020/7/20.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.mid = dic[@"mid"];
        self.message = dic[@"message"];
        self.name = dic[@"name"];
        self.iconURL = dic[@"picture"];
        self.time = dic[@"time"];
        self.unreadCount = dic[@"unreadCount"];
    }
    return self;
}

+ (id)dataInject:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

@end
