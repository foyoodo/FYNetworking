//
//  FYURLRequest.m
//  FYNetworking
//
//  Created by foyoodo on 2022/2/10.
//

#import "FYURLRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation FYURLRequest

+ (instancetype)requestWithMethod:(NSString *)method
                        URLString:(NSString *)URLString
{
    return [[self alloc] initWithMethod:method URLString:URLString];
}

- (instancetype)initWithMethod:(NSString *)method
                     URLString:(NSString *)URLString
{
    if (self = [super init]) {
        _method = method;
        _URLString = URLString;
    }
    return self;
}

- (NSURLRequest *)URLRequest
{
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:self.method
                                                         URLString:self.URLString
                                                        parameters:self.params
                                                             error:nil];
}

@end
