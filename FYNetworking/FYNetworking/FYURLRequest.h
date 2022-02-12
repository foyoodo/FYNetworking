//
//  FYURLRequest.h
//  FYNetworking
//
//  Created by foyoodo on 2022/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYURLRequest : NSObject

+ (instancetype)requestWithMethod:(NSString *)method
                        URLString:(NSString *)URLString;

- (instancetype)initWithMethod:(NSString *)method
                     URLString:(NSString *)URLString;

@property (nonatomic, strong, readonly) NSURLRequest *URLRequest;

@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
