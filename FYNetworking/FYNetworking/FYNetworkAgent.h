//
//  FYNetworkAgent.h
//  FYNetworking
//
//  Created by foyoodo on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FYCallback)(void);

@interface FYNetworkAgent : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)addRequest:(NSURLRequest *)request
                 success:(FYCallback)success
                 failure:(FYCallback)failure;

- (void)cancelRequestWithTaskID:(NSNumber *)taskID;
- (void)cancelRequestWithTaskIDList:(NSArray *)taskIDList;

@end

NS_ASSUME_NONNULL_END
