//
//  HWViewController.m
//  AirPlayTest
//
//  Created by 朱唯辰 on 13/2/26.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import "HWViewController.h"


@interface HWViewController ()

@end


@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //        [self pickAMirroredRoute];
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



@end
