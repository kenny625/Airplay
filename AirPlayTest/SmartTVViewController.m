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
    
    taskCount=0;
    nowTask=-1;
    nowStatus=-1;
    
    
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
    [[appDelegate getTVController] pickRouteAtIndex:0];
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
    
    
    [self performSelector:@selector(showToast) withObject:nil afterDelay:5];
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
                
                [self changeStatus:[realSenseView showOnTV]];
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
                [self changeStatus:-1];
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
        [self changeStatus:-1];
    }
    
    else{
        NSLog(@"%d",buttonIndex);
        HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate getTVController] pickRouteAtIndex:[[tableData objectAtIndex:(buttonIndex-1)] getTVID]];
        [self changeStatus:buttonIndex-1];
        
    }


}

-(void)changeStatus:(int)s{
    nowStatus=s;
    if(nowStatus==nowTask){
        [toast removeFromSuperview];
        [self performSelector:@selector(showToast) withObject:nil afterDelay:5];
    }
}

-(void)showToast{
    taskCount++;
    if(taskCount>10){
        HWAppDelegate *appDelegate = (HWAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate getTVController] pickRouteAtIndex:0 ];
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
        return;
    }
    nowTask = arc4random() % 2;
    if(nowTask==nowStatus){
        nowTask=-1;
        
    }
    if(nowTask>=0){
        [toast setText:[NSString stringWithFormat:@"請投影照片到\n%@",[[tableData objectAtIndex:nowTask]getName]]] ;
    }
    else{
        [toast setText:@"請取消投影照片"] ;
    }
    [self.view addSubview:toast];
    
}


- (void)writeIntoFile_inFile:(NSString*)fileNameInput andContent:(NSString*)stringInput andAppend:(BOOL)appendInput{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = fileNameInput;
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    NSString *stringNew=stringInput;
    
    NSString *aString;
    if(appendInput){
        aString=[NSString stringWithFormat:@"%@\r%@",[[NSString alloc]initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding],stringNew];//把舊的文件先換行，再把新的加上去
    }else{
        aString=[NSString stringWithFormat:@"%@",stringNew];//把舊的文件先換行，再把新的加上去
    }
    
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath options:NSDataWritingAtomic error:nil];
    //
    //
    // Build the path...
    NSString *SP=[[NSString alloc]initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",SP);
}
@end