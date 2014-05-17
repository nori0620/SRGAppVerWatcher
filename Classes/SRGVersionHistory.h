//
//  SRGVersionHistory.h
//  SRGAppVerWatcher
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGVersionRecord.h"

@interface SRGVersionHistory : NSObject< NSCoding >

- (void)addRecord:(SRGVersionRecord *)record;
- (SRGVersionRecord *)firstRecord;
- (SRGVersionRecord *)latestRecord;
- (SRGVersionRecord *)previoustRecord;
- (BOOL)isEmpty;
- (SRGVersionRecord *)recordOf:(NSString *)version;

@end
