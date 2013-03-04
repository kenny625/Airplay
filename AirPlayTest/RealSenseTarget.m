//
//  RealSenseTarget.m
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/4.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import "RealSenseTarget.h"

@implementation RealSenseTarget
- (id)initWithTarget:(DisplayData*)t{
    self= [super initWithFrame:CGRectMake(0,0, 30,30)];
    if(self){
        target=t;
        myDegree=[t getDegree];
        [self setImage:[UIImage imageNamed:@"tvicon.jpg"]];
        [self setBackgroundColor:[target getColor]];
        
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 100,20)];
        [label setText:[target getName]];
//        [label setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor: [UIColor clearColor]];
        [self addSubview:label];
    }
return self;

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
        x=160+(degree/180.f*160.f);
    }
    else{
        x=((degree-180)/180.f*160.f);
    }
    
    if(selectSize==3){
        x=160;
    }
    self.frame=CGRectMake(x-radius, 0, radius*2, radius*2);

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
    if(f){
    NSLog(@"set select");
    }
    flagSelect=f;
    [self setSize:3];
}
-(bool)getSelect{
    return flagSelect;
}
@end
