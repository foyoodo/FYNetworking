//
//  FYNetworkAgent.m
//  FYNetworking
//
//  Created by foyoodo on 2022/2/9.
//

#import <AFNetworking/AFNetworking.h>
#import "FYNetworkAgent.h"

@interface FYNetworkAgent ()

@property (nonatomic, strong) NSMutableDictionary *taskDispatchTable;

@end

@implementation FYNetworkAgent

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSNumber *)addRequest:(NSURLRequest *)request success:(FYCallback)success failure:(FYCallback)failure
{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [[AFHTTPSessionManager manager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *taskID = @(dataTask.taskIdentifier);
        [self.taskDispatchTable removeObjectForKey:taskID];

        if (error) {
            !failure ?: failure();
        } else {
            !success ?: success();
        }
    }];

    NSNumber *taskID = @(dataTask.taskIdentifier);
    self.taskDispatchTable[taskID] = dataTask;
    [dataTask resume];

    return taskID;
}

- (void)cancelRequestWithTaskID:(NSNumber *)taskID
{
    NSURLSessionDataTask *dataTask = self.taskDispatchTable[taskID];
    [dataTask cancel];
    [self.taskDispatchTable removeObjectForKey:taskID];
}

- (void)cancelRequestWithTaskIDList:(NSArray *)taskIDList
{
    for (NSNumber *taskID in taskIDList) {
        [self cancelRequestWithTaskID:taskID];
    }
}

#pragma mark - Getter & Setter

- (NSMutableDictionary *)taskDispatchTable
{
    if (!_taskDispatchTable) {
        _taskDispatchTable = [NSMutableDictionary dictionary];
    }
    return _taskDispatchTable;
}

@end
