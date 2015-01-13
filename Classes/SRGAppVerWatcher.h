//
//  SRGAppVerWatcher.h
//  SRGAppVerWatcher
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGVersionHistory.h"

@interface SRGAppVerWatcher : NSObject

typedef void (^SRGBlockAfterInstall)();
typedef void (^SRGBlockAfterUpdate)(NSString *before, NSString *to);

+ (instancetype)sharedWatcher;

- (void)watch;
- (void)executeOnceAfterInstall:(SRGBlockAfterInstall)block;
- (void)executeOnceAfterUpdate:(SRGBlockAfterUpdate)block;

- (NSDate *)installDate;
- (NSString *)installVersion;

- (NSDate *)updateDate;
- (NSDate *)updateDateOf:(NSString *)version;

- (void) clear;
- (void) fakeCurrentVersion:(NSString *)version;


@end
