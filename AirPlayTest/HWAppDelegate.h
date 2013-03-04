//
//  HWAppDelegate.h
//  AirPlayTest
//
//  Created by 朱唯辰 on 13/2/26.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayData.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPAudioDeviceController.h"
@interface HWAppDelegate : UIResponder <UIApplicationDelegate>{
    NSMutableArray* targets;
    MPAudioDeviceController *audoDeviceController;
}

@property (strong, nonatomic) UIWindow *window;
-(NSMutableArray*)getTargets;
-(MPAudioDeviceController *)getTVController;
@end
