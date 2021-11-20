//
//  FDownloadTupleQueue.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//


#import <Foundation/Foundation.h>

@class FDownloadTask;
@class FDownloadTuple;

@interface FDownloadTupleQueue : NSObject

@property (nonatomic, strong, readonly) NSMutableArray * tuples;

- (FDownloadTuple *)tupleWithDownloadTask:(FDownloadTask *)downloadTask;
- (NSArray <FDownloadTuple *> *)tuplesWithDownloadTasks:(NSArray <FDownloadTask *> *)downloadTasks;
- (FDownloadTuple *)tupleWithDownloadTask:(FDownloadTask *)downloadTask sessionTask:(NSURLSessionDownloadTask *)sessionTask;

- (void)addTuple:(FDownloadTuple *)tuple;
- (void)removeTupleWithSesstionTask:(NSURLSessionTask *)sessionTask;
- (void)removeTuple:(FDownloadTuple *)tuple;
- (void)removeTuples:(NSArray <FDownloadTuple *> *)tuples;

- (void)cancelDownloadTask:(FDownloadTask *)downloadTask resume:(BOOL)resume completionHandler:(void(^)(FDownloadTuple * tuple))completionHandler;
- (void)cancelDownloadTasks:(NSArray <FDownloadTask *> *)downloadTasks resume:(BOOL)resume completionHandler:(void(^)(NSArray <FDownloadTuple *> * tuples))completionHandler;

- (void)cancelAllTupleResume:(BOOL)resume completionHandler:(void(^)(NSArray <FDownloadTuple *> * tuples))completionHandler;
- (void)cancelTuple:(FDownloadTuple *)tuple resume:(BOOL)resume completionHandler:(void(^)(FDownloadTuple * tuple))completionHandler;
- (void)cancelTuples:(NSArray <FDownloadTuple *> *)tuples resume:(BOOL)resume completionHandler:(void(^)(NSArray <FDownloadTuple *> * tuples))completionHandler;

@end
