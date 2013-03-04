//
//  SmartTVViewController.h
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "RealSenseView.h"
#import "HWAppDelegate.h"
@interface SmartTVViewController : UIViewController<CLLocationManagerDelegate,UIActionSheetDelegate>{
    RealSenseView* realSenseView;
    UIActionSheet* tvActionSheet;
    UIImageView* animeView;
    UILabel* toast;
    bool flagShowing;
    CGPoint touchPoint;
    
    NSMutableArray* tableData;
    
    
}
@property(nonatomic, strong) CLLocationManager *locationManager;

@property (strong) NSNumber* mode;


@end