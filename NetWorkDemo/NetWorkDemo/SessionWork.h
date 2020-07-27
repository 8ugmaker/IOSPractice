//
//  SessionWork.h
//  NetWorkDemo
//
//  Created by huyanxin on 2020/7/27.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionWork : NSObject

+ (void)getDataFromURL:(void(^)(NSArray *))completion;

@end

NS_ASSUME_NONNULL_END
