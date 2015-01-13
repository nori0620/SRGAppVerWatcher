//
//  SRGAppVerWatcher.m
//  SRGAppVerWatcher
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import "SRGAppVerWatcher.h"

@implementation SRGAppVerWatcher {
    NSUserDefaults *_userDefaults;
   
    SRGVersionHistory *_versionHistory;
    BOOL _enableInstallDispatcher;
    BOOL _enableUpdateDispatcher;
    
    NSString *_fakedVersion;
}

static SRGAppVerWatcher *_sharedWatcher = nil;
static NSString *PersistentHistoryKey = @"SRGAppVerWatcher.History";

+ (instancetype)sharedWatcher {
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWatcher = [[[self class] alloc] init];
    });
    return _sharedWatcher;
}

- (instancetype)init {
    if( self = [super init]){
        _userDefaults = [NSUserDefaults standardUserDefaults];
        [self p_loadHistory];
        [self watch];
    }
    return self;
}

- (void) watch {
    _enableInstallDispatcher = _versionHistory.isEmpty;
    _enableUpdateDispatcher  = (
        !_versionHistory.isEmpty
            &&
        ![_versionHistory.latestRecord
            isEqualVersionTo: [self p_appVersion]
        ]
    );
    if( _enableInstallDispatcher || _enableUpdateDispatcher){
        [self p_addCurrentVersionToRecord];
    }
}

- (void) p_addCurrentVersionToRecord {
    [_versionHistory addRecord:
        [SRGVersionRecord
            recordWithVersion:[self p_appVersion]
            date:[self p_now]
         ]
    ];
    [self p_persistHistory];
}


#pragma mark Dispatcher
- (void)executeOnceAfterInstall:(SRGBlockAfterInstall)block{
    if( !_enableInstallDispatcher ){ return; }
    block();
    _enableInstallDispatcher = NO;
}

- (void)executeOnceAfterUpdate:(SRGBlockAfterUpdate)block{
    if( !_enableUpdateDispatcher  ){ return; }
    NSString *from = _versionHistory.previoustRecord.version;
    NSString *to   = _versionHistory.latestRecord.version;
    block(from,to);
    _enableUpdateDispatcher = NO;
}

#pragma mark Version History Getter

- (NSDate *)installDate {
    return _versionHistory.isEmpty
        ? nil
        : _versionHistory.firstRecord.date;
}

- (NSString *)installVersion {
    return _versionHistory.isEmpty
        ? nil
        : _versionHistory.firstRecord.version;
}

- (NSDate *)updateDate {
    return _versionHistory.isEmpty
        ? nil
        : _versionHistory.latestRecord.date;
}

- (NSDate *)updateDateOf:(NSString *)version {
    SRGVersionRecord *record = [_versionHistory
        recordOf:version
    ];
    return record.date;
}

#pragma mark PrivateMethos/Persister

- (void)p_persistHistory {
    NSData *data = [NSKeyedArchiver
        archivedDataWithRootObject:_versionHistory
    ];
    [_userDefaults setObject: data
                      forKey: PersistentHistoryKey];
    [_userDefaults synchronize];
}

- (void)p_loadHistory {
    NSData *data = [_userDefaults objectForKey:PersistentHistoryKey];
    _versionHistory = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if( !_versionHistory ){
        _versionHistory = [SRGVersionHistory new];
    }
}

- (void)fakeCurrentVersion:(NSString *)version {
    _fakedVersion = version;
}

#pragma mark Helpers
- (NSString *) p_appVersion {
    if( _fakedVersion ){ return _fakedVersion; }
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSDate *) p_now{
    return [NSDate date];
}

- (void)clear {
    [_userDefaults removeObjectForKey:PersistentHistoryKey];
    [_userDefaults synchronize];
    [self p_loadHistory];
}

@end
