SRGAppVerWatcher
===========

SRGAppVerWatcher detect app-install or app-update, and you can your run code  just   one time at  after app-install or app-updates by using blocks.

## Installation

Add the following line to your podfile and run `pod update`.
```ruby
pod 'SRGAppVerWatcher', :git => 'https://github.com/soragoto/SRGAppVerWatcher.git', :tag => '0.0.1'
```

## Usage

At first you need to include header file.
```objc
#import "SRGAppVerWatcher.h"
```

You can use a block that run just one time at after application install.
```objc
[[SRGAppVerWatcher sharedWatcher] executeOnceAfterInstall:^{
    // This blocks run just one time after install.
    // ( This block DOSE NOT RUN at after update )
    [yourObject introduceAppFeatures];
}];
```
You can use a block that run just one time at after application updates. 
- Blocks argments `NSString *from` : app-version before update.
- Blocks argments `NSString *to` :  app-version after update.

```objc
[[SRGAppVerWatcher sharedWatcher] executeOnceAfterUpdate:^(NSString *from, NSString*to){
    // This blocks run just one time after update.
    // ( This block DOSE NOT RUN at after install )
    [yourObject showWatsNewInUpdate];
    NSLog(@"Update version from:%@ to:%@",from,to);
}];
```

You can get date an app is installed ( or update ).
```objc
NSDate *installDate     = [[SRGAppVerWatcher sharedWatcher] installDate];
NSDate *updateDate      = [[SRGAppVerWatcher sharedWatcher] updateDate];
NSDate *updateDateVer3  = [[SRGAppVerWatcher sharedWatcher] updateDateOf:@"3.0"];
```

You can get version when app is installed .
```objc
NSString *installVersion = [[SRGAppVerWatcher sharedWatcher] installVersion];
```

## Notes

SRGAppVerWatcher detect update or install by saving current version and compare previous version. So you need to install SRGAppVerWatcher from FIRST VERSION in your app, otherwise SRGAppVerWatcher can't distinguish between update and install.
