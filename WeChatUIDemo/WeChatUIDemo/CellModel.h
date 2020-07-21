//
//  CellModel.h
//  WeChatUIDemo
//
//  Created by huyanxin on 2020/7/20.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellModel : NSObject

@property(nonatomic, copy) NSString *mid;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *iconURL;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *unreadCount;

+ (id)dataInject:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
