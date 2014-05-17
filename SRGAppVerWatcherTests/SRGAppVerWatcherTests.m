//
//  SRGAppVerWatcherTests.m
//  SRGAppVerWatcherTests
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SRGAppVerWatcherTests.m"
#import "SRGAppVerWatcher.h"

@interface SRGAppVerWatcher (Mock)

- (NSString *) _appVersion;

@end

@interface SRGAppVerWatcherTests : XCTestCase

@end

@implementation SRGAppVerWatcherTests {
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
    [self _mockVersion:@"1.0"];
    
    
    [_watcher watch];
    
    /* First dispatch after install */
    __block BOOL isDispatched;
    isDispatched = NO;
    [_watcher dispatchOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertTrue(isDispatched);
    
    isDispatched = NO;
    [_watcher dispatchOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    XCTAssertTrue(_watcher.installDate);
    XCTAssertEqualObjects(_watcher.installVersion,@"1.0");
    
    /* Second dispatch after install */
    isDispatched = NO;
    [_watcher dispatchOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    isDispatched = NO;
    [_watcher dispatchOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    /* Update Version */
    [self _mockVersion:@"2.0"];
    [_watcher watch];
    
    /* First dispatch after update */
    isDispatched = NO;
    [_watcher dispatchOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    isDispatched = NO;
    [_watcher dispatchOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
        XCTAssertEqualObjects(from,@"1.0");
        XCTAssertEqualObjects(to  ,@"2.0");
    }];
    XCTAssertTrue(isDispatched);
    
    /* Second dispatch after update */
    isDispatched = NO;
    [_watcher dispatchOnceAfterInstall:^{
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    isDispatched = NO;
    [_watcher dispatchOnceAfterUpdate:^(NSString *from, NSString*to){
        isDispatched = YES;
    }];
    XCTAssertFalse(isDispatched);
    
    /* UpdateDate */
    XCTAssertTrue([_watcher updateDateOf:@"1.0"]);
    XCTAssertTrue([_watcher updateDateOf:@"2.0"]);
    XCTAssertFalse([_watcher updateDateOf:@"3.0"]);
}

- (void) _mockVersion:(NSString *)version {
    _watcher = [OCMockObject partialMockForObject:
        [SRGAppVerWatcher sharedWatcher]
    ];
    OCMockObject *mock = (OCMockObject *)_watcher;
    [[[mock expect] andReturn:version] _appVersion];
}

@end
