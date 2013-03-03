//
//  HWViewController.m
//  AirPlayTest
//
//  Created by 朱唯辰 on 13/2/26.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import "HWViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPAudioDeviceController.h"

@interface HWViewController ()

@end


@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    [self pickAMirroredRoute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id second=segue.destinationViewController;
    

    NSNumber* i=[NSNumber numberWithInt:_modeButton.selectedSegmentIndex];
    [second setValue:i forKey:@"mode"];
    
}

- (void)pickAMirroredRoute {
    MPAudioDeviceController *audoDeviceController = [[MPAudioDeviceController alloc] init];
    audoDeviceController.routeDiscoveryEnabled = YES;
    
    [audoDeviceController determinePickableRoutesWithCompletionHandler:^(NSInteger value) {
        NSMutableArray *routes = [NSMutableArray array];
        [audoDeviceController clearCachedRoutes];
        
        NSUInteger index = 0;
        while (true) {
            NSDictionary *route = [audoDeviceController routeDescriptionAtIndex:index];
            if (route) {
                [routes addObject:route];
                index++;
            } else {
                //                NSLog(@"%@", routes);
                break;
            }
        }
        
        [routes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj objectForKey:@"RouteSupportsAirPlayScreen"] boolValue]) {
                NSDictionary *info = [obj objectForKey:@"AirPlayPortExtendedInfo"];
                NSString *deviceID = [info objectForKey:@"deviceID"];
                if ([[info objectForKey:@"uid"] isEqualToString:[NSString stringWithFormat:@"%@-screen", deviceID]]) {
                    [audoDeviceController pickRouteAtIndex:idx];
                    //有多台apple TV時，把這個idx存到一個地方，之後就可以根據idx選要用哪一台mirror
                }
            }
            NSLog(@"%@  ",obj);
        }];
    }];
    
}

@end
