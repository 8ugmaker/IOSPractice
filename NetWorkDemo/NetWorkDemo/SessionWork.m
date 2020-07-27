//
//  SessionWork.m
//  NetWorkDemo
//
//  Created by huyanxin on 2020/7/27.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import "SessionWork.h"

@implementation SessionWork

+ (void)getDataFromURL:(void(^)(NSArray *))completion
{
    NSURL *URL = [NSURL URLWithString:@"http://example.com/data"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    __block NSArray *array;
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        completion(array);
    }];
    [task resume];
}

@end
