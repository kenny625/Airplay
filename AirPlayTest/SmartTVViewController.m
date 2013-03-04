//
//  SmartTVViewController.m
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import "SmartTVViewController.h"

@implementation SmartTVViewController
@synthesize locationManager;
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    flagShowing=NO;
    //toast
    toast=[[UILabel alloc]initWithFrame:CGRectMake(50, 200, 200, 100)];
    [toast setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [toast setTextColor:[UIColor whiteColor]];
    [toast setTextAlignment:NSTextAlignmentCenter];
    [toast setFont:[toast.font fontWithSize:25]];
    [toast setNumberOfLines:2];
    //realsense
    HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
    //    tableData=[[appDelegate getTargets] copy];
    tableData=[appDelegate getTargets];
    
    
    
    realSenseView=[[RealSenseView alloc]initWithFrame:CGRectMake(0,0,320,45) Target:[appDelegate getTargets] Controller:[appDelegate getTVController]];
    
    
    //menu
    
    tvActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"iPhone", nil];
    
    
    for(DisplayData* d in tableData){
        [tvActionSheet addButtonWithTitle:[d getName]];
    }
    tvActionSheet.cancelButtonIndex = [tvActionSheet addButtonWithTitle:@"Cancel"];
    
    
    //navigationBar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"離開"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"分享"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clickRightButton)];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    [self.view addSubview:navigationBar];
    
    
    //photo
    UIImageView* photoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 420)];
    [photoView setImage:[UIImage imageNamed:@"photo.jpg"]];
    
    [self.view addSubview:photoView];
    
    animeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 420)];
    [animeView setImage:[UIImage imageNamed:@"photo.jpg"]];
    [photoView setBackgroundColor:[UIColor redColor]];
    
    //campass
    if([_mode integerValue]==1){
        locationManager=[[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.headingFilter = 3;
        
        if (locationManager.headingAvailable){
            NSLog(@"start campass");
            [locationManager startUpdatingHeading];
        }
    }
    
    
    [self performSelector:@selector(showToast) withObject:nil afterDelay:3];
}
-(void)clickLeftButton{
    UIStoryboard *storyboard = self.storyboard;
    HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate getTVController] pickRouteAtIndex:0 ];
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(void)clickRightButton{
    if([_mode integerValue]==0){
        //        [self.view addSubview:alertView];
        //        [alertView show];
        [tvActionSheet showInView:self.view];
    }
    else if([_mode integerValue]==1){
        [self.view addSubview:realSenseView];
        flagShowing=YES;
        [realSenseView setShowing:YES];
    }
}


-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    if([_mode integerValue]==1){
        if(flagShowing){
            touchPoint=[[touches anyObject] locationInView:self.view];
        }
    }
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([_mode integerValue]==1){
        
        if(flagShowing){
            CGPoint endPoint=[[touches anyObject] locationInView:self.view];
            [realSenseView setShowing:NO];
            [realSenseView removeFromSuperview];
            flagShowing=NO;
            if(touchPoint.y-endPoint.y>100){
                
                [realSenseView showOnTV];
                animeView.frame=CGRectMake(0, 44, 320, 420);
                [self.view addSubview:animeView];
                [UIView beginAnimations:@"state" context:nil];
                [UIView setAnimationDuration: 1];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(hideAnime) ];
                
                animeView.frame=CGRectMake(0,-420, 320, 420);
                [UIView commitAnimations];
            }
            else if(touchPoint.y-endPoint.y<-100){
                HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
                [[appDelegate getTVController] pickRouteAtIndex:0 ];
            }
        }
    }
}
-(void)hideAnime{
    [animeView removeFromSuperview];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // Convert Degree to Radian and move the needle
    if (newHeading.headingAccuracy > 0) {
        CLLocationDirection theHeading = newHeading.magneticHeading;
        [realSenseView updateDegree:theHeading];
        //        NSLog(@"!!%f",theHeading);
    }
}
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    //        NSLog(@"orientation change");
    return YES;
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex==tvActionSheet.cancelButtonIndex){
        return;
    }
    else if(buttonIndex==0){
        HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate getTVController] pickRouteAtIndex:0];
    }
    
    else{
        NSLog(@"%d",buttonIndex);
        HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate getTVController] pickRouteAtIndex:[[tableData objectAtIndex:(buttonIndex-1)] getTVID]];
        
    }
    [toast removeFromSuperview];
    [self performSelector:@selector(showToast) withObject:nil afterDelay:3];
}
-(void)showToast{
    [toast setText:@"請投影照片到\napple tv"];
    [self.view addSubview:toast];
}
@end