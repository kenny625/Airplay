//
//  TestModeViewController.m
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/3.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import "TestModeViewController.h"

@implementation TestModeViewController
@synthesize locationManager;
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
    //    tableData=[[appDelegate getTargets] copy];
    tableData=[appDelegate getTargets];
    
    
    
    realSenseView=[[RealSenseView alloc]initWithFrame:CGRectMake(0,0,320,45) Target:[appDelegate getTargets] Controller:[appDelegate getTVController]];
    
    flagShowing=NO;
    
    tvActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"iPhone", nil];
    
    
    for(DisplayData* d in tableData){
        [tvActionSheet addButtonWithTitle:[d getName]];
    }
    tvActionSheet.cancelButtonIndex = [tvActionSheet addButtonWithTitle:@"Cancel"];
    
    /*
     //    alertView=[[UIAlertView alloc]initWithFrame:CGRectMake(50,200,220,150)];
     alertView=[[UIAlertView alloc]initWithTitle:@"分享" message:@"\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
     //    [alertView setBackgroundColor:[UIColor redColor]];
     tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150)
     style:UITableViewStyleGrouped];
     [tableView setDelegate:self];
     [tableView setDataSource:self];
     [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection: 0] animated:NO scrollPosition:UITableViewScrollPositionNone];
     [alertView addSubview:tableView];
     */
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
/*
 -(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
 CGPoint p = [[touches anyObject] locationInView:self];
 if((p.x-touchPoint.x)*(p.x-touchPoint.x)+
 (p.y-touchPoint.y)*(p.y-touchPoint.y)<radius*radius){
 for(DisplayData* d in targets){
 [d setSelect:NO];
 }
 }
 else{
 
 float td=[self touchDegree:p];
 for(DisplayData* d in targets){
 if(td-[d getDegree]<0){
 td+=360;
 }
 if(td-[d getDegree]<=targetWidth){
 [d setSelect:YES];
 }
 }
 }
 [self setNeedsDisplay];
 }
 
 */


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

    if(buttonIndex==0){
        HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate getTVController] pickRouteAtIndex:0];
    }
    else if(buttonIndex==tvActionSheet.cancelButtonIndex){
        return;
    }
    else{
        NSLog(@"%d",buttonIndex);
        HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate getTVController] pickRouteAtIndex:[[tableData objectAtIndex:(buttonIndex-1)] getTVID]];
        
    }
}
/*
 //TableView
 
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 
 
 static NSString *CellIdentifier = @"Cell";
 
 //初始化cell并指定其类型，也可自定义cell
 
 UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if(cell == nil)  {
 cell = [[UITableViewCell alloc] initWithFrame:CGRectZero  reuseIdentifier:CellIdentifier] ;
 
 }
 DisplayData* d=[tableData objectAtIndex:indexPath.row];
 [[cell textLabel]  setText:[d getName]];
 
 return cell;
 
 }
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return tableData.count;
 
 
 }
 //指定有多少个分区(Section)，默认为1
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
 return 1;
 
 }
 - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 NSLog(@"select %d",indexPath.row);
 
 [alertView dismissWithClickedButtonIndex:0 animated:YES];
 
 HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
 [[appDelegate getTVController] pickRouteAtIndex:[[tableData objectAtIndex:indexPath.row] getTVID]];
 }
 */
@end