//
//  SRGVersionRecord.h
//  SRGAppVerWatcher
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRGVersionRecord : NSObject< NSCoding >

@property (readonly) NSString *version;
@property (readonly) NSDate *date;

+ (instancetype) recordWithVersion:(NSString *)version
                              date:(NSDate *)date
;
- (BOOL) isEqualVersionTo:(NSString *)version;

@end
