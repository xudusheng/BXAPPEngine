//
//  XDSTaskQueue.h
//
//  Copyright (c) 2014 xudusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTask.h"

@class BXTaskQueue;
typedef void(^XDSTaskQueueFinishedBlock)(BXTaskQueue * taskQueue);

@interface BXTaskQueue : NSObject

@property (nonatomic, assign) NSInteger maxConcurrentTaskCount;
@property (nonatomic, strong, readonly) NSArray * tasks;

+ (BXTaskQueue *)taskQueue;
- (void)addTask:(BXTask *)task;
- (BXTask *)taskWithTaskId:(NSString *)taskId;
- (void)cancelAllTasks;
- (void)resetQueue;
- (void)go;
- (void)goWithFinishedBlock:(XDSTaskQueueFinishedBlock)block;

@end
