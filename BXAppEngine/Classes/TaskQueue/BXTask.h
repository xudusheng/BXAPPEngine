//
//  XDSTask.h
//
//  Copyright (c) 2014 xudusheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    XDSTaskWait = 0,
    XDSTaskExecuting,
    XDSTaskFinished,
    XDSTaskCancelled,
}XDSTaskState;

@class BXTask;
typedef void(^XDSTaskStateChangedBlock)(BXTask * task);
typedef void(^XDSTaskContentBlock)(BXTask * task);

@interface BXTask : NSObject

@property (nonatomic, copy) NSString * taskId;
@property (nonatomic, readonly) XDSTaskState taskState;
@property (nonatomic, copy) XDSTaskContentBlock taskContentBlock;
@property (nonatomic, copy) XDSTaskStateChangedBlock taskStateChangedBlock;
@property (nonatomic, strong, readonly) NSArray *dependencies;
@property (nonatomic, strong) id userInfo;

+ (BXTask *)task;
- (void)addDependency:(BXTask *)task;
- (void)removeDependency:(BXTask *)task;
- (void)executeBlockContent;
- (void)taskHasFinished;
- (void)cancelTask;

@end
