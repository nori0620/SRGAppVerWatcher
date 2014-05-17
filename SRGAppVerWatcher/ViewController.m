//
//  ViewController.m
//  SRGAppVerWatcher
//
//  Created by nori0620 on 2014/05/16.
//  Copyright (c) 2014年 soragoto. All rights reserved.
//

#import "ViewController.h"
#import "SRGAppVerWatcher.h"

@interface ViewController ()

@end

@implementation ViewController {
    SRGAppVerWatcher *_appVerWatcher;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appVerWatcher = [SRGAppVerWatcher sharedWatcher];
    
    __weak typeof(self) weakSelf = self;
    [_appVerWatcher executeOnceAfterInstall:^{
        [weakSelf _showMessageOnInstall];
    }];
    [_appVerWatcher executeOnceAfterUpdate:^(NSString *from,NSString *to){
        [weakSelf _showMessageOnUpdateWithFrom:from
                                            to:to];
    }];
    [self _showDetailToLog];
}

- (void) _showMessageOnInstall {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title   = @"Thank you for installing!";
    alert.message = [NSString stringWithFormat:
        @"InstallVersion:%@", _appVerWatcher.installVersion
    ];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

- (void) _showMessageOnUpdateWithFrom:(NSString *)from
                                   to:(NSString *)to
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title   = @"Thank you for Updating!";
    alert.message = [NSString stringWithFormat:
        @"Update from %@ to %@\n",from,to
    ];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}

- (void) _showDetailToLog {
    NSLog(@"InstallVersion:%@",_appVerWatcher.installVersion);
    NSLog(@"InstallDate:%@",_appVerWatcher.installDate);
    NSLog(@"UpdateDate:%@",_appVerWatcher.updateDate);
    NSLog(@"date of updating to 1.0 : %@",
          [_appVerWatcher updateDateOf:@"1.0"]
    );
    NSLog(@"date of updating to 2.0 : %@",
          [_appVerWatcher updateDateOf:@"2.0"]
    );
    NSLog(@"date of updating to 3.0 : %@",
          [_appVerWatcher updateDateOf:@"3.0"]
    );
}


@end
