//
//  FYNetworkManager.m
//  FYNetworking
//
//  Created by foyoodo on 2022/2/9.
//

#import "FYNetworkManager.h"
#import "FYNetworkAgent.h"
#import "FYURLRequest.h"

@interface FYNetworkManager ()

@property (nonatomic, strong) NSMutableArray *requestTaskIDList;

@property (nonatomic, copy) void (^successBlock)(FYNetworkManager *manager);
@property (nonatomic, copy) void (^failureBlock)(FYNetworkManager *manager);

@end

@implementation FYNetworkManager

- (void)dealloc
{
    [self cancelAllRequests];
}

- (instancetype)init
{
    if (self = [super init]) {
        _delegate = nil;
    }
    return self;
}

#pragma mark - Request

- (NSNumber *)requestWithParams:(NSDictionary *)params
{
    if (![self.delegate respondsToSelector:@selector(request)]) {
        return @0;
    }

    if (params) {
        self.delegate.request.params = params;
    }

    NSNumber *requestTaskID = [[FYNetworkAgent sharedInstance] addRequest:self.delegate.request.URLRequest success:^{
        [self requestDidSucceed];
    } failure:^{
        [self requestDidFail];
    }];

    [self.requestTaskIDList addObject:requestTaskID];

    return requestTaskID;
}

- (NSNumber *)requestWithParams:(NSDictionary *)params
                        success:(FYRequestCompletionBlock)successBlock
                        failure:(FYRequestCompletionBlock)failureBlock
{
    [self setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    return [self requestWithParams:params];
}

- (NSNumber *)request
{
    return [self requestWithParams:nil];
}

- (NSNumber *)requestWithSuccess:(FYRequestCompletionBlock)successBlock
                         failure:(FYRequestCompletionBlock)failureBlock
{
    [self setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    return [self requestWithParams:nil];
}

- (void)cancelAllRequests
{
    [[FYNetworkAgent sharedInstance] cancelRequestWithTaskIDList:self.requestTaskIDList];
    [self.requestTaskIDList removeAllObjects];
}

- (void)cancelRequestWithTaskID:(NSNumber *)taskID
{
    [[FYNetworkAgent sharedInstance] cancelRequestWithTaskID:taskID];
    [self.requestTaskIDList removeObject:taskID];
}

- (void)requestDidSucceed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidSucceed:)]) {
        [self.delegate requestDidSucceed:self];
    }

    !self.successBlock ?: self.successBlock(self);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearCompletionBlock];
    });
}

- (void)requestDidFail
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFail:)]) {
        [self.delegate requestDidFail:self];
    }

    !self.failureBlock ?: self.failureBlock(self);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearCompletionBlock];
    });
}

#pragma mark - Configuration

- (void)setCompletionBlockWithSuccess:(FYRequestCompletionBlock)successBlock
                              failure:(FYRequestCompletionBlock)failureBlock
{
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
}

- (void)clearCompletionBlock
{
    self.successBlock = nil;
    self.failureBlock = nil;
}

#pragma mark - Getter & Setter

- (NSMutableArray *)requestTaskIDList
{
    if (!_requestTaskIDList) {
        _requestTaskIDList = [NSMutableArray array];
    }
    return _requestTaskIDList;
}

@end
