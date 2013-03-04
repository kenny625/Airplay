//
//  RealSenseView.m
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import "RealSenseView.h"

@implementation RealSenseView

- (id)initWithFrame:(CGRect)frame Target:(NSMutableArray*)t Controller:(MPAudioDeviceController *)c{
    self=[super initWithFrame:frame];
    if(self){
        audoDeviceController=c;
        [self setBackgroundColor:[UIColor blackColor]];
        flagShowing=NO;
        
        targets=t;
        targetCount=targets.count;
        targetWidth=360/(targetCount+1);
        
        
        realSenseTargets=[[NSMutableArray alloc]initWithCapacity:0];
        for(DisplayData* d in targets){
            RealSenseTarget* t=[[RealSenseTarget alloc]initWithTarget:d];
            [realSenseTargets addObject:t];
            [self addSubview:t];
        }
    }
    return self;
}

-(float)degreeToAngle:(float)d{
    return d/180*M_PI;
    
}

-(float)touchDegree:(CGPoint) p{
    
    float deg =((int) ((atan2( p.y - touchPoint.y,p.x - touchPoint.x)+M_PI) / M_PI * 180 + 180)) % 360;
    return deg;
}

-(void)updateDegree:(float)d{
    if(targets.count==0){
        return;
    }
    pointDegree=d;
    for(RealSenseTarget* t in realSenseTargets){
        [t setDegree:d];
    }
    
    float minD=360;
    int minID=-1;
    for(int i=0;i<targets.count;i++){
        RealSenseTarget* t=[realSenseTargets objectAtIndex:i];
        
        [t setSelect:NO];
        float tmpD=[t getDegree]-pointDegree;
        if(tmpD<0){
            tmpD=-tmpD;
        }
        
        if(tmpD>180){
            tmpD=360-tmpD;
        }
        if(tmpD<minD){
            minD=tmpD;
            minID=i;
        }
        
        if(tmpD<=60){
            [t setSize:2];
        }
        else if(tmpD<120){
            [t setSize:1];
        }
        else{
            [t setSize:0];
        }
        
        
    }
    
    [(RealSenseTarget*)[realSenseTargets objectAtIndex:minID]setSelect:YES];
    [self bringSubviewToFront:[realSenseTargets objectAtIndex:minID]];
}
-(void)showOnTV{
    for(RealSenseTarget* t in realSenseTargets){
        if([t getSelect]){
            [audoDeviceController pickRouteAtIndex:[t getTVID]];
            break;
        }
        
    }
}


@end
