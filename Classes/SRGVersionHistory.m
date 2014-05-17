//
//  SRGVersionHistory.m
//  SRGAppVerWatcher
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import "SRGVersionHistory.h"

@implementation SRGVersionHistory {
    NSMutableArray *_records;
    
}

- (id)init {
    if( self = [super init]){
        _records = @[].mutableCopy;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if( [self init]){
       _records = [decoder decodeObjectForKey:@"records"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_records forKey:@"records"];
}

- (void)addRecord:(SRGVersionRecord *)record {
    [_records addObject:record];
}

- (SRGVersionRecord *)firstRecord {
    return _records.firstObject;
}

- (SRGVersionRecord *)latestRecord {
    return _records.lastObject;
}
- (SRGVersionRecord *)previoustRecord {
    if( _records.count < 2){ return  nil; }
    return _records[ _records.count-2 ];
}

- (BOOL)isEmpty {
    return _records.count == 0;
}

- (SRGVersionRecord *) recordOf:(NSString *)version {
    for (SRGVersionRecord *record in _records ){
        if( [record.version isEqualToString:version]){
            return record;
        }
    }
    return nil;
}


@end
