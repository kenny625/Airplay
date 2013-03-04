//
//  SetTVViewController.m
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/3.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import "SetTVViewController.h"

@implementation SetTVViewController
@synthesize locationManager,tableView;
- (void)viewDidLoad
{
    
    HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
    tableData=[appDelegate getTargets];
    [tableData removeAllObjects];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    //campass
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.headingFilter = 3;
    
    if (locationManager.headingAvailable){
        NSLog(@"start campass");
        [locationManager startUpdatingHeading];
    }
    [self pickAMirroredRoute];
    
    
}
- (IBAction)setDeg:(id)sender{
    
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    if(selectedIndexPath !=nil){
        int index=selectedIndexPath.row;
        
        DisplayData* d=[tableData objectAtIndex:index];
        [d setDegree:nowDeg];
        [tableView reloadData];
    }
    
    
}
- (void)pickAMirroredRoute {
    HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
    MPAudioDeviceController *audoDeviceController = [appDelegate getTVController];    audoDeviceController.routeDiscoveryEnabled = YES;
    
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
                NSString *deviceName=[obj objectForKey:@"RouteName"];
                
                if ([[info objectForKey:@"uid"] isEqualToString:[NSString stringWithFormat:@"%@-screen", deviceID]]) {
                    
                    DisplayData* d=[[DisplayData alloc]initWithId:tableData.count Degree:0 Name:deviceName];
                    [d setTVID:idx];
                    [tableData addObject:d];
                    [tableView reloadData];
                    NSLog(@"%@  ",obj);
                    
                    /*
                     [audoDeviceController pickRouteAtIndex:idx];
                     //有多台apple TV時，把這個idx存到一個地方，之後就可以根據idx選要用哪一台mirror
                     */
                }
            }
        }];
    }];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // Convert Degree to Radian and move the needle
    if (newHeading.headingAccuracy > 0) {
        CLLocationDirection theHeading = newHeading.magneticHeading;
        nowDeg=(float)theHeading;
        [_degLabel setText:[NSString stringWithFormat:@"%d度",(int)theHeading]];
        
    }
}
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    //        NSLog(@"orientation change");
    return YES;
}

- (IBAction)buttonClicked:(id)sender{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

//TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    //初始化cell并指定其类型，也可自定义cell
    
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)  {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero  reuseIdentifier:CellIdentifier] ;
        
    }
    DisplayData* d=[tableData objectAtIndex:indexPath.row];
    [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%f",[d getName],[d getDegree]]];
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableData.count;
    
    
}
//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
@end
