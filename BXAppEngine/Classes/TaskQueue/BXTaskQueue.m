//
//  XDSTaskQueue.m
//
//  Copyright (c) 2014 xudusheng. All rights reserved.
//

#import "BXTaskQueue.h"
#import <CoreGraphics/CoreGraphics.h>

@interface XDSTaskQueueTimerTarget : NSObject


@property (nonatomic, weak) id owner;
@property (nonatomic, assign) SEL selector;

- (id)initWithOwner:(id)owner selector:(SEL)selector;
- (void)update;
- (void)update:(id)object;

@end

@implementation XDSTaskQueueTimerTarget

- (id)initWithOwner:(id)owner selector:(SEL)selector {
    self = [super init];
    if (self){
        _owner = owner;
        _selector = selector;
    }
    return self;
}

- (void)update {
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([(NSObject *)_owner respondsToSelector:_selector]) {
        [_owner performSelector:_selector];
    }
#       pragma clang diagnostic pop
}

- (void)update:(id)object
{
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([(NSObject *)_owner respondsToSelector:_selector]) {
        [_owner performSelector:_selector withObject:object];
    }
#       pragma clang diagnostic pop
}

@end


@interface BXTaskQueue ()

@property (nonatomic, strong) NSMutableArray * queueTasks;
@property (nonatomic, strong) XDSTaskQueueTimerTarget * timerTarget;
@property (nonatomic, assign) CGFloat scanningInterval;
@property (nonatomic, assign) BOOL queueHasStarted;
@property (nonatomic, strong) XDSTaskQueueFinishedBlock taskQueueFinishedBlock;

@end

@implementation BXTaskQueue

+ (BXTaskQueue *)taskQueue
{
    return [[BXTaskQueue alloc] init];
}

- (id)init
{
    if (self = [super init]) {
        self.maxConcurrentTaskCount = 5;
        self.scanningInterval = 0.1;
        self.queueTasks = [NSMutableArray array];
        self.timerTarget = [[XDSTaskQueueTimerTarget alloc] initWithOwner:self selector:@selector(updateAllTask)];
    }
    return self;
}

#pragma mark - Public methods

- (NSArray *)tasks
{
    return self.queueTasks;
}

- (void)addTask:(BXTask *)task
{
    if (![self.queueTasks containsObject:task]) {
        [self.queueTasks addObject:task];
        
        if (self.queueHasStarted) {
            [self updateAllTask];
        }
    }
}

- (void)cancelAllTasks
{
    for (BXTask * task in self.queueTasks) {
        [task cancelTask];
    }
    self.queueTasks = [NSMutableArray array];
}

- (BXTask *)taskWithTaskId:(NSString *)taskId
{
    for (BXTask * task in self.queueTasks) {
        if ([task.taskId isEqualToString:taskId]) {
            return task;
        }
    }
    
    return nil;
}

- (void)go
{
    self.queueHasStarted = YES;
    [self.timerTarget update];
}

- (void)goWithFinishedBlock:(XDSTaskQueueFinishedBlock)block
{
    self.taskQueueFinishedBlock = block;
    
    [self go];
}

- (void)resetQueue
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.timerTarget selector:@selector(update) object:nil];
    [self cancelAllTasks];
    self.queueHasStarted = NO;
}

#pragma mark - Private methods

- (void)updateAllTask
{
    @try {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self.timerTarget selector:@selector(update) object:nil];
        
        if (self.queueTasks.count) {
            
            NSMutableArray * willExecuteTask = [NSMutableArray array];
            NSMutableArray * willRemoveTask = [NSMutableArray array];
            NSMutableArray * executingTask = [NSMutableArray array];
            NSInteger canExecuteTaskCount = 0;
            
            for (BXTask * task in self.queueTasks) {
                if (task.taskState == XDSTaskExecuting) {
                    [executingTask addObject:task];
                }
            }
            
            canExecuteTaskCount = self.maxConcurrentTaskCount - executingTask.count;
            canExecuteTaskCount = canExecuteTaskCount >=0 ? canExecuteTaskCount : 0;
            
            for (BXTask * task in self.queueTasks) {
                if (task.dependencies.count == 0 && task.taskState == XDSTaskWait) {
                    //root task
                    [willExecuteTask addObject:task];
                }else {
                    //sub task
                    BOOL canExecuteTask = YES;
                    for (BXTask * depTask in task.dependencies) {
                        if (depTask.taskState == XDSTaskWait || depTask.taskState == XDSTaskExecuting) {
                            canExecuteTask = NO;
                            break;
                        }
                    }
                    if (canExecuteTask) {
                        [willExecuteTask addObject:task];
                    }
                }
                
                if (task.taskState == XDSTaskFinished || task.taskState == XDSTaskCancelled) {
                    [willRemoveTask addObject:task];
                }
            }
            
            if (willRemoveTask.count) {
                [self.queueTasks removeObjectsInArray:willRemoveTask];
            }
            
            if (willExecuteTask.count > canExecuteTaskCount) {
                [willExecuteTask subarrayWithRange:NSMakeRange(0, canExecuteTaskCount)];
            }
            
            for (BXTask * task in willExecuteTask) {
                if (task.taskState == XDSTaskWait) {
                    [task executeBlockContent];
                }
            }
            
            [self.timerTarget performSelector:@selector(update) withObject:nil afterDelay:self.scanningInterval];
            
        }else {
            
            if (self.taskQueueFinishedBlock) {
                self.taskQueueFinishedBlock(self);
            }
            
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Update Queue Task Exception");
    }
    @finally {
        
    }
}

@end
