//
//  TestModeViewController.h
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/3.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "RealSenseView.h"
#import "HWAppDelegate.h"

@interface TestModeViewController : UIViewController<CLLocationManagerDelegate,UIActionSheetDelegate>{
    RealSenseView* realSenseView;
//    UIAlertView* alertView;
    
//    UITableView* tableView;
    UIActionSheet* tvActionSheet;
    UIImageView* animeView;
    
    bool flagShowing;
    CGPoint touchPoint;
    
    NSMutableArray* tableData;
    
    
}
@property(nonatomic, strong) CLLocationManager *locationManager;

@property (strong) NSNumber* mode;


@end