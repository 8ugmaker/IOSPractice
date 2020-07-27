//
//  Model.h
//  NetWorkDemo
//
//  Created by huyanxin on 2020/7/27.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *iconURL;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *unreadCount;

+ (id)dataInject:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
