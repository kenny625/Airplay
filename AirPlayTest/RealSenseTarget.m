//
//  RealSenseTarget.m
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/4.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import "RealSenseTarget.h"

@implementation RealSenseTarget
- (id)initWithTarget:(DisplayData*)t Delegate:(id<touchprotocol>)d{
    self= [super initWithFrame:CGRectMake(0,0, 30,30)];
    if(self){
        target=t;
        delegate=d;
        myDegree=[t getDegree];
        [self setUserInteractionEnabled:YES];
        [self setImage:[UIImage imageNamed:@"tvicon.jpg"]];
        [self setBackgroundColor:[target getColor]];
        
        label=[[UILabel alloc]initWithFrame:CGRectMake(-20,0, 100,20)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[target getName]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor: [target getColor]];
        [self addSubview:label];
    }
    return self;
    
}
-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    //    NSLog(@"touch realsense traget");
    [delegate touchAt:[target getSelfID]];
}
-(NSUInteger)getTVID{
    return [target getTVID];
}
-(void)setDegree:(float)d{
    pointDegree=d;
    float x;
    float radius;
    switch (selectSize) {
        case 0:
            radius=15;
            
            break;
        case 1:
            radius=20;
            break;
        case 2:
            radius=25;
            break;
        case 3:
            radius=30;
            break;
            
    }

    float degree=myDegree-pointDegree;
    
    while(degree<0){
        degree+=360;
    }
    
    if(degree<=180){
        x=175+(degree/180.f*145.f);
    }
    else{
        x=((degree-180)/180.f*145.f);
    }
    
    if(selectSize==3){
        x=160;
    }
    
    float moveX=self.frame.origin.x-x;
    if(moveX<0){
        moveX=-moveX;
    }
    [UIView beginAnimations:@"state" context:nil];
    [UIView setAnimationDuration: 1.5*moveX/320.f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAnime) ];
    label.frame=CGRectMake(-20, radius*2-20*radius/30.f, 100, 20*radius/30.f);
    self.frame=CGRectMake(x-radius, 0, radius*2, radius*2);
    [UIView commitAnimations];

    
    
}
-(float)getDegree{
    return myDegree;
}
-(void)setSize:(int)s{
    selectSize=s;
}
-(int)getSize{
    return selectSize;
}
-(void)setSelect:(bool)f{
    flagSelect=f;
    if(f){
        [self setSize:3];
    }
}
-(bool)getSelect{
    return flagSelect;
}
@end
