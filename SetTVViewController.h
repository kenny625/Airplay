//
//  SetTVViewController.h
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/3.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MPAudioDeviceController.h"
#import "HWAppDelegate.h"

@interface SetTVViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>{
    float nowDeg;
    NSMutableArray* tableData;
}
@property (strong) NSNumber* mode;

@property(nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,strong)IBOutlet UILabel* degLabel;
@property (nonatomic,strong)IBOutlet UITableView* tableView;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)setDeg:(id)sender;
@end
