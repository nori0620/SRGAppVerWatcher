//
//  SRGAppVerWatcherTests.m
//  SRGAppVerWatcherTests
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SRGAppVerWatcherTests.m"
#import "SRGAppVerWatcher.h"

@interface SRGAppVerWatcher (Mock)

- (NSString *) p_appVersion;

@end

@interface SRGAppVerWatcherTests : XCTestCase

@end

@implementation SRGAppVerWatcherTests {
    BOOL _isMockWatcher;
    SRGAppVerWatcher *_watcher;
}

- (void)setUp {
    [super setUp];
    _watcher = [SRGAppVerWatcher sharedWatcher];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    
    /* Install Version */
    [_watcher clear];
    [self p_mockVersion:@"1.0"];
    
    
    [_watcher watch];
    
    /* First execute after install */
    __block BOOL isDispatched;
    isDispatched = NO;
    [_watcher executeOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertTrue(isDispatched);
    
    isDispatched = NO;
    [_watcher executeOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    XCTAssertTrue(_watcher.installDate);
    XCTAssertEqualObjects(_watcher.installVersion,@"1.0");
    
    /* Second execute after install */
    isDispatched = NO;
    [_watcher executeOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    isDispatched = NO;
    [_watcher executeOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    /* Update Version */
    [self p_mockVersion:@"2.0"];
    [_watcher watch];
    
    /* First execute after update */
    isDispatched = NO;
    [_watcher executeOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    isDispatched = NO;
    [_watcher executeOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
        XCTAssertEqualObjects(from,@"1.0");
        XCTAssertEqualObjects(to  ,@"2.0");
    }];
    XCTAssertTrue(isDispatched);
    
    /* Second execute after update */
    isDispatched = NO;
    [_watcher executeOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    isDispatched = NO;
    [_watcher executeOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    /* UpdateDate */
    XCTAssertTrue([_watcher updateDateOf:@"1.0"]);
    XCTAssertTrue([_watcher updateDateOf:@"2.0"]);
    XCTAssertFalse([_watcher updateDateOf:@"3.0"]);
}

- (void) p_mockVersion:(NSString *)version {
    [_watcher fakeCurrentVersion:version];
}

@end
