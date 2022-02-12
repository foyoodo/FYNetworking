//
//  FYNetworkManager.h
//  FYNetworking
//
//  Created by foyoodo on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FYNetworkManager;
@class FYURLRequest;

@protocol FYNetworkManagerDelegate <NSObject>

@required

- (FYURLRequest *)request;

@optional

- (void)requestDidSucceed:(FYNetworkManager *)manager;
- (void)requestDidFail:(FYNetworkManager *)manager;

@end

typedef void(^FYRequestCompletionBlock)(FYNetworkManager *manager);

@interface FYNetworkManager : NSObject

- (NSNumber *)requestWithParams:(nullable NSDictionary *)params;

- (NSNumber *)requestWithParams:(nullable NSDictionary *)params
                        success:(nullable FYRequestCompletionBlock)successBlock
                        failure:(nullable FYRequestCompletionBlock)failureBlock;


- (NSNumber *)request;
- (NSNumber *)requestWithSuccess:(FYRequestCompletionBlock)successBlock
                         failure:(FYRequestCompletionBlock)failureBlock;

- (void)cancelAllRequests;
- (void)cancelRequestWithTaskID:(NSNumber *)taskID;

@property (nonatomic, weak) id<FYNetworkManagerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
