//
//  RealSenseView.m
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import "RealSenseView.h"

@implementation RealSenseView

- (id)initWithFrame:(CGRect)frame Target:(NSMutableArray*)t{
    self=[super initWithFrame:frame];
    if(self){
        
        [self setBackgroundColor:[UIColor blackColor]];
        flagShowing=NO;
        
        targets=t;
        targetCount=targets.count;
        targetWidth=360/(targetCount+1);

        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(targets.count==0){
        return;
    }
    float minD=360;
    int minID=-1;
    for(int i=0;i<targets.count;i++){
        DisplayData* d=[targets objectAtIndex:i];
        
        float tmpD=[d getDegree]-pointDegree;
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
            [d setSize:2];
        }
        else if(tmpD<120){
            [d setSize:1];
        }
        else{
            [d setSize:0];
        }
        
        
    }
    DisplayData* d=[targets objectAtIndex:minID];
    [d setSize:3];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for(DisplayData* d in targets){
        float radius;
        switch ([d getSize]) {
            case 0:
                radius=25;
                break;
            case 1:
                radius=30;
                break;
            case 2:
                radius=40;
                break;
            case 3:
                radius=45;
                break;
                
        }
        
        float x;
        
        float degree=[d getDegree]-pointDegree;
        
        while(degree<0){
            degree+=360;
        }
        
        if(degree<=180){
            x=160+(degree/180.f*160.f);
        }
        else{
            x=((degree-180)/180.f*160.f);
        }
        
        if([d getSize]==3){
            x=160;
        }
        
        CGRect circleRect=CGRectMake(x -radius ,45-radius,radius*2, radius*2);
        
        CGContextAddEllipseInRect(ctx, circleRect);
        CGContextSetFillColor(ctx,CGColorGetComponents([[d getColor] CGColor]));
        CGContextFillPath(ctx);
        
    }
    
    //垂繪目標使目標永遠在最上面
    float  x=160;
    float radius=45;
    
    CGRect circleRect2=CGRectMake(x -(radius+10) ,45-(radius+10),(radius+10)*2, (radius+10)*2);
    
    CGContextAddEllipseInRect(ctx, circleRect2);
    CGContextSetFillColor(ctx,CGColorGetComponents([[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]));
    CGContextFillPath(ctx);
    
    
    CGRect circleRect=CGRectMake(x -radius ,45-radius,radius*2, radius*2);
    
    CGContextAddEllipseInRect(ctx, circleRect);
    CGContextSetFillColor(ctx,CGColorGetComponents([[d getColor] CGColor]));
    CGContextFillPath(ctx);
    
    
    /*
     //繞邊邊跑(方向好像反了)
     for(DisplayData* d in targets){
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     float degree=[d getDegree]-pointDegree;
     if(degree<0){
     degree+=360;
     }
     
     float x=160,y=230;
     
     if(degree>=326||degree<=34){
     x=160-280*sin(degree/180*M_PI);
     y=0;
     
     
     CGRect circleRect2=CGRectMake(x -(radius+15) ,y-(radius+15),(radius+15)*2, (radius+15)*2);
     
     
     CGContextAddEllipseInRect(ctx, circleRect2);
     CGContextSetFillColor(ctx,CGColorGetComponents([[UIColor colorWithRed:115/255.f green:189/255.f blue:253/255.f alpha:1] CGColor]));
     CGContextFillPath(ctx);
     
     }
     else if(degree>=214){
     x=320;
     y=230-280*sin((degree-270)/180*M_PI);
     }
     else if(degree>=146){
     x=160+280*sin((degree-180)/180*M_PI);
     y=460;
     }
     else{
     x=0;
     y=230+280*sin((degree-90)/180*M_PI);
     }
     
     CGRect circleRect=CGRectMake(x -radius ,y-radius,radius*2, radius*2);
     
     CGContextAddEllipseInRect(ctx, circleRect);
     CGContextSetFillColor(ctx,CGColorGetComponents([[d getColor] CGColor]));
     CGContextFillPath(ctx);
     }
     */
    /*
     
     //舊版realsense gesture
     if(flagShowing) {
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     //        for(int i=0;i<targetCount;i++){
     for(DisplayData* d in targets){
     UIBezierPath *aPath ;
     if([d getSelect]){
     aPath= [UIBezierPath bezierPathWithArcCenter:touchPoint radius:radius*1.5 startAngle:[self degreeToAngle:[d getDegree]]  endAngle:[self degreeToAngle:([d getDegree]+targetWidth)] clockwise:YES];
     }
     else{
     aPath= [UIBezierPath bezierPathWithArcCenter:touchPoint radius:radius*1.1 startAngle:[self degreeToAngle:[d getDegree]]  endAngle:[self degreeToAngle:([d getDegree]+targetWidth)] clockwise:YES];
     
     
     }
     
     
     CGContextSetStrokeColor(ctx, CGColorGetComponents([[d getColor] CGColor]));
     
     [aPath setLineWidth:radius];
     [aPath stroke];
     }
     
     
     CGRect circleRect2=CGRectMake(touchPoint.x -(radius+5) ,touchPoint.y-(radius+5),(radius+5)*2, (radius+5)*2);
     
     CGContextAddEllipseInRect(ctx, circleRect2);
     CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:74/255.f green:167/255.f blue:224/255.f alpha:1] CGColor]));
     CGContextFillPath(ctx);
     
     CGRect circleRect=CGRectMake(touchPoint.x -radius ,touchPoint.y-radius,radius*2, radius*2);
     
     CGContextAddEllipseInRect(ctx, circleRect);
     CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:115/255.f green:189/255.f blue:253/255.f alpha:1] CGColor]));
     CGContextFillPath(ctx);
     
     }
     */
}
-(float)degreeToAngle:(float)d{
    return d/180*M_PI;
    
}

-(float)touchDegree:(CGPoint) p{
    
    
    float deg =((int) ((atan2( p.y - touchPoint.y,p.x - touchPoint.x)+M_PI) / M_PI * 180 + 180)) % 360;
    return deg;
}
-(void)updateDegree:(float)d{
    pointDegree=d;
    [self setNeedsDisplay];
}
@end
